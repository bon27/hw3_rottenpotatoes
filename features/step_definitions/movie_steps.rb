# Add a declarative step here for populating the DB with movies.

Given /^the following movies exist:$/ do |movies|
  movies.hashes.each do |movie|
  # record = movie.cols_hash
  # each returned element will be a hash whose key is the table header.
  # you should arrange to add that movie to the database here.
  Movie.create!(:title=>movie[:title],:rating=>movie[:rating],:release_date=>movie[:release_date])
  end
  #flunk "Unimplemented"
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  steps %Q{
   Then I should see \"#{e1}\"
   Then I should see \"#{e2}\"
  }
  content = page.body
  movie1 = content.index(e1)
  movie2 = content.index(e2)
  assert movie1 < movie2
    
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /^I (un)?check the ratings "(.*)"$/ do |uncheck, rating_list|
   # HINT: use String#split to split up the rating_list, then
  rating_list.split(/,/).each do |rating|
     if uncheck
        step( "I uncheck \"ratings_#{rating}\"") 
     else
	step( "I check \"ratings_#{rating}\"")
     end
  end 
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Given /^I check the following ratings: "(.*)"/ do |rating_list|
 @all_ratings = Movie.all_ratings
 checked_ratings = rating_list.split(/,/)
 unchecked_ratings = @all_ratings - checked_ratings
 checked_ratings = checked_ratings.join(",")
 unchecked_ratings = unchecked_ratings.join(",")
 steps %Q{
    Given I check the ratings \"#{checked_ratings}\"
    Given I uncheck the ratings \"#{unchecked_ratings}\"
 }
end

Then /^I should see the following movies exist:$/ do |movies|
   # should compare the movie record in the database and the page
   #record_movies = Movie.find(:all,:ratings=>@checked_ratings)
   #rated_movie = all("table#movies tbody tr").count
   movies.hashes.each do |movie|
     step("I should see \"#{movie[:title]}\"")
   #record_num  = movies.hashes.length
   #rated_movie.should == record_num   
   end
   record_num = movies.hashes.length
   rated_movie = all("table#movies tbody tr").count
   rated_movie.should == record_num
end


Given /^I check all the ratings$/ do
  steps %Q{
     Given I check the following ratings: "G,PG,PG-13,NC-17,R"
     When  I press "Refresh"
  }
end

Then /^I should see all of the movies$/ do
  within_table('movies') do
    @rows = all("tbody tr").count
 end
 value = Movie.find(:all).length
 #rows = (#movies.find(tbody).find(tr).length
 @rows.should == value
end

  


