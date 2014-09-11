require 'spec_helper'

describe Post do


  #Validations
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should validate_presence_of(:onid)}
  it {should validate_presence_of(:location)}
end
