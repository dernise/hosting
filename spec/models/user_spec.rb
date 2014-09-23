require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'invalid email' do
    dernise = User.new(username: 'dernise', password: 'test123', email: 'derniselive.fr', name: 'Henneron', surname: 'Maxence')
    expect(dernise.save).to (eq(false))
    expect(dernise.errors.count).to (eq(1))

    dernise.errors.full_messages.each do |msg|
      puts msg
    end
  end

  it 'account is created' do
    dernise = User.new(username: 'dernise', password: 'test123', email: 'dernise@live.fr', name: 'Henneron', surname: 'Maxence')
    expect(dernise.save).to (eq(true))
  end

  it 'password is encrypted' do
    dernise = User.new(username: 'dernise', password: 'test123', email: 'dernise@live.fr', name: 'Henneron', surname: 'Maxence')
    expect(dernise.save).to (eq(true))
    expect(dernise.authenticate('test123')).to (eq(dernise))
  end

  it 'user is unique' do
    dernise = User.new(username: 'dernise', password: 'test123', email: 'dernise@live.fr', name: 'Henneron', surname: 'Maxence')
    expect(dernise.save).to (eq(true))
    dernise2 = User.new(username: 'dernise', password: 'test123', email: 'dernise2@live.fr', name: 'Henneron', surname: 'Maxence')
    expect(dernise2.save).to (eq(false))
  end

  it 'email is unique' do
    dernise = User.new(username: 'dernise', password: 'test123', email: 'dernise@live.fr', name: 'Henneron', surname: 'Maxence')
    expect(dernise.save).to (eq(true))
    dernise2 = User.new(username: 'dernises', password: 'test123', email: 'dernise@live.fr', name: 'Henneron', surname: 'Maxence')
    expect(dernise2.save).to (eq(false))
  end
end
