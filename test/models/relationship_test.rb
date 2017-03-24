require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @relationship = Relationship.new(follower_id: users(:chris).id, followed_id: users(:ben).id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follwer_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end
