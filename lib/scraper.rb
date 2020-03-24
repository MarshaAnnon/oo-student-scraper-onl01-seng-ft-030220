require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    students = []

    doc.css("div.roster-cards-container").each do |student_info|
      
      student_info.css(".student-card").each do |student|
      students_hash = {}
      students_hash[:name] = student.css("a div.card-text-container h4.student-name").text
      students_hash[:location] = student.css("a div.card-text-container p.student-location").text
      students_hash[:profile_url] = student.css("a").attribute("href").value
      students << students_hash
      end
    end 
    students 
  end
  

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile_hash = {}

    doc.css(".social-icon-container").children.css("a").each do |element|
      
      if element.attribute("href").value.include?("twitter")
        profile_hash[:twitter] = element.attribute("href").value
      elsif element.attribute("href").value.include?("linkedin")
        profile_hash[:linkedin] = element.attribute("href").value
      elsif element.attribute("href").value.include?("github")
        profile_hash[:github] = element.attribute("href").value
      elsif element.attribute("href").value.include?("blog")
      else
        profile_hash[:blog] = element.attribute("href").value
      end
    end
        profile_hash[:profile_quote] = doc.css("div.profile-quote").text
        profile_hash[:bio] = doc.css("div.description-holder p").text
        profile_hash
  end

end

    
  