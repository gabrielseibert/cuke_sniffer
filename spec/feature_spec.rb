require 'spec_helper'

describe Feature do

  before(:each) do
    @file_name = "my_feature.feature"
    file = File.open(@file_name, "w")
    file.puts("@tag1 @tag2")
    file.puts("@tag3")
    file.puts("\#@tag4")
    file.puts("Feature: My features are in this")
    file.puts("")
    file.puts("@simple_tag")
    file.puts("Scenario: My Test Scenario")
    file.puts("Given I want to be a test")
    file.puts("When I become a test")
    file.puts("Then I am a test")
    file.puts("")
    file.puts("@fun_tag")
    file.puts("Scenario: My Test Scenario 2")
    file.puts("Given I want to be a test")
    file.puts("When I become a test")
    file.puts("Then I am a test")
    file.close
    @feature = Feature.new(@file_name)
  end

  after(:each) do
    File.delete(@file_name)
  end

  it "should parse a feature file and gather the feature name" do
    @feature.location.should == @file_name
    @feature.name.should == "My features are in this"
  end

  it "should gather all non commented feature level tags" do
    @feature.tags.should == ["@tag1", "@tag2", "@tag3"]
  end

  it "should gather a scenario with its tags and create a scenario object and add feature level tags to the scenario" do
    scenario_1_text = [
        "@simple_tag",
        "Scenario: My Test Scenario",
        "Given I want to be a test",
        "When I become a test",
        "Then I am a test"
    ]
    expected_scenario_1 = Scenario.new("my_feature.feature:7", scenario_1_text)
    expected_scenario_1.tags += @feature.tags

    scenario_2_text = [
        "@fun_tag",
        "Scenario: My Test Scenario 2",
        "Given I want to be a test",
        "When I become a test",
        "Then I am a test"
    ]

    expected_scenario_2 = Scenario.new("my_feature.feature:5", scenario_2_text)
    expected_scenario_2.tags += @feature.tags

    @feature.scenarios.length.should == 2
    @feature.scenarios[0].should == expected_scenario_1
    @feature.scenarios[1].tags.should == expected_scenario_2.tags
  end

end