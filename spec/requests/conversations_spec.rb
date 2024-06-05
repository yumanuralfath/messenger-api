require 'rails_helper'

RSpec.describe 'Conversations API', type: :request do
  let(:dimas) { create(:user) }
  let(:dimas_headers) { valid_headers(dimas) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid) }

  describe 'GET /conversations' do
    context 'when user have no conversation' do
      # make HTTP get request before each example
      before { get '/conversations', params: {}, headers: dimas_headers }

      it 'returns empty data with 200 code' do
        expect_response(
          :ok,
          data: []
        )
      end
    end

    context 'when user have conversations' do
      # TODOS: Populate database with conversation of current user
      let!(:conversations) { create_list(:conversation, 5, user1: dimas, user2: samid) }

      before do
        get '/conversations', params: {}, headers: dimas_headers
      end

      it 'returns list conversations of current user' do
        # Note `response_data` is a custom helper
        # to get data from parsed JSON responses in spec/support/request_spec_helper.rb

        expect(response_body).not_to be_empty
        expect(response_body.size).to eq(5)
      end

      it 'returns status code 200 with correct response' do
        expect_response(:ok)
        expect(response_body).to all(match(
          id: a_kind_of(Integer),
          with_user: a_hash_including(
            id: a_kind_of(Integer),
            name: a_kind_of(String),
            photo_url: a_kind_of(String)
          ),
          last_message: a_hash_including(
            id: a_kind_of(Integer),
            sender: a_hash_including(
              id: a_kind_of(Integer),
              name: a_kind_of(String)
            ),
            sent_at: a_kind_of(String)
          ),
          unread_count: a_kind_of(Integer)
        ))
      end
    end
  end

  describe 'GET /conversations/:id' do
    context 'when the record exists' do
      # TODO: create conversation of dimas

      # create a conversation for dimas
      let!(:convo_id) { conversation.id }
      let!(:conversation) { create(:conversation, user1: dimas, user2: samid) }
      before { get "/conversations/#{convo_id}", params: {}, headers: dimas_headers }

      it 'returns conversation detail' do
      expect_response(:ok)
      expect(response_body).to match(
        id: a_kind_of(Integer),
        with_user: a_hash_including(
          id: a_kind_of(Integer),
          name: a_kind_of(String),
          photo_url: a_kind_of(String)
        ),
        last_message: a_hash_including(
          id: a_kind_of(Integer),
          sender: a_hash_including(
            id: a_kind_of(Integer),
            name: a_kind_of(String)
          ),
          sent_at: a_kind_of(String)
        ),
        unread_count: a_kind_of(Integer)
      )
    end
  end

    context 'when current user access other user conversation' do
      let!(:other_user) { create(:user) }
      let!(:convo_id) { conversation.id }
      let!(:conversation) { create(:conversation, user1: dimas, user2: other_user) }
      before { get "/conversations/#{convo_id}", params: {}, headers: samid_headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the record does not exist' do
      before { get "/conversations/-11", params: {}, headers: dimas_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
