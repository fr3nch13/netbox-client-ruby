# frozen_string_literal: true

require 'spec_helper'

RSpec.describe NetboxClientRuby::DCIM::InterfaceConnection, faraday_stub: true do
  let(:entity_id) { 9 }
  let(:expected_connection_status) { true }
  let(:base_url) { '/api/dcim/interface-connections/' }
  let(:response) { File.read("spec/fixtures/dcim/interface-connection_#{entity_id}.json") }

  let(:request_url) { "#{base_url}#{entity_id}/" }

  subject { described_class.new entity_id }

  describe '#id' do
    it 'shall be the expected id' do
      expect(subject.id).to eq(entity_id)
    end
  end

  describe '#connection_status' do
    it 'should fetch the data' do
      expect(faraday).to receive(:get).and_call_original

      expect(subject.connection_status['value']).to_not be_nil
    end

    it 'shall be the expected connection_status' do
      expect(subject.connection_status['value']).to eq(expected_connection_status)
    end
  end

  describe '.delete' do
    let(:request_method) { :delete }
    let(:response_status) { 204 }
    let(:response) { nil }

    it 'should delete the object' do
      expect(faraday).to receive(request_method).and_call_original
      subject.delete
    end
  end

  describe '.update' do
    let(:request_method) { :patch }
    let(:request_params) { { 'connection_status' => false } }

    it 'should update the object' do
      expect(faraday).to receive(request_method).and_call_original
      expect(subject.update(connection_status: false).connection_status['value']).to eq(expected_connection_status)
    end
  end

  describe '.reload' do
    it 'should reload the object' do
      expect(faraday).to receive(request_method).twice.and_call_original

      subject.reload
      subject.reload
    end
  end

  describe '.save' do
    let(:connection_status) { true }
    let(:request_params) { { 'connection_status' => connection_status } }

    context 'update' do
      let(:request_method) { :patch }

      subject do
        entity = described_class.new entity_id
        entity.connection_status = connection_status
        entity
      end

      it 'does not call PATCH until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.connection_status).to eq(connection_status)
      end

      it 'calls PATCH when save is called' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the PATCH answer' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save
        expect(subject.connection_status['value']).to eq(expected_connection_status)
      end
    end

    context 'create' do
      let(:request_method) { :post }
      let(:request_url) { base_url }

      subject do
        entity = described_class.new
        entity.connection_status = connection_status
        entity
      end

      it 'does not POST until save is called' do
        expect(faraday).to_not receive(request_method)
        expect(faraday).to_not receive(:get)

        expect(subject.connection_status).to eq(connection_status)
      end

      it 'POSTs the data upon a call of save' do
        expect(faraday).to receive(request_method).and_call_original

        expect(subject.save).to be(subject)
      end

      it 'Reads the answer from the POST' do
        expect(faraday).to receive(request_method).and_call_original

        subject.save

        expect(subject.id).to be(entity_id)
        expect(subject.connection_status['value']).to eq(expected_connection_status)
      end
    end
  end
end
