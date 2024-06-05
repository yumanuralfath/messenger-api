require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  let(:agus) { create(:user) }
  let(:dimas) { create(:user) }
  let(:dimas_headers) { valid_headers(dimas) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid) }

  # TODO: create conversation between Dimas and Agus, then set convo_id variable
  let!(:conversation) { create(:conversation, user1: dimas, user2: agus) }
  let!(:convo_id) { conversation.id }

  describe 'get list of messages' do
    context 'when user have conversation with other user' do
      before { get "/conversations/#{convo_id}/messages", params: {}, headers: dimas_headers }

      it 'returns list all messages in conversation' do
        expect_response(
          :ok,
          data: [
            {
              id: Integer,
              message: String,
              sender: {
                id: Integer,
                name: String
              },
              sent_at: String
            }
          ]
        )
      end
    end

    context 'when user try to access conversation not belong to him' do
      # TODO: create conversation and set convo_id variable
      let!(:conversation) { create(:conversation, user1: samid, user2: agus) }
      let!(:convo_id) { conversation.id }
      before { get "/conversations/#{convo_id}/messages", params: {}, headers: dimas_headers }

      it 'returns error 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when user try to access invalid conversation' do
      # TODO: create conversation and set convo_id variable
      let!(:conversation) { create(:conversation, user1: agus, user2: samid) }
      let!(:convo_id) { conversation.id }
      before { get "/conversations/-11/messages", params: {}, headers: samid_headers }

      it 'returns error 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'send message' do
    let(:valid_attributes) do
      { message: 'Hi there!', recipient_id: agus.id }
    end

    let(:invalid_attributes) do
      { message: '', recipient_id: agus.id }
    end

    context 'when request attributes are valid' do
      before { post "/messages", params: valid_attributes, headers: dimas_headers, as: :json }

      it 'returns status code 201 (created) and create conversation automatically' do
        expect_response(
          :created,
          data: {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String
            },
            sent_at: String,
            conversation: {
              id: Integer,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String
              }
            }
          }
        )
      end
    end

    context 'when create message into existing conversation' do
      before { post "/messages", params: valid_attributes, headers: dimas_headers, as: :json}

      it 'returns status code 201 (created) and create conversation automatically' do
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)

        expect(response_json).to include(
          'id' => a_kind_of(Integer),
          'message' => a_kind_of(String),
          'sender' => a_hash_including(
            'id' => a_kind_of(Integer),
            'name' => a_kind_of(String)
          ),
          'sent_at' => a_kind_of(String),
          'conversation' => a_hash_including(
            'id' => convo_id,
            'with_user' => a_hash_including(
              'id' => a_kind_of(Integer),
              'name' => a_kind_of(String),
              'photo_url' => a_kind_of(String)
            )
          )
        )
      end
    end

    context 'when an invalid request' do
      before { post "/messages", params: invalid_attributes, headers: dimas_headers, as: :json}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
