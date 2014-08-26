require 'spec_helper'

describe Post do

  #Relations
  it {should belong_to(:user)}

  #Validations
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:user_id)}
  
end
