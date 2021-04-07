# insert your copyright here

# see the URL below for information on how to write OpenStudio measures
# http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/

# start the measure
class UrbanOptScenarios < OpenStudio::Measure::ModelMeasure
  # human readable name
  def name
    # Measure name should be the title case of the class name.
    return 'UrbanOptScenarios'
  end

  # human readable description
  def description
    return 'Change UrbanOpt Scenario CSV'
  end

  # human readable description of modeling approach
  def modeler_description
    return 'Change UrbanOpt Scenario CSV'
  end

  # define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new

    # the name of the space to add to the model
    scenario_file_name = OpenStudio::Measure::OSArgument.makeStringArgument('scenario_file_name', true)
    scenario_file_name.setDisplayName('Scenario File name')
    scenario_file_name.setDescription('This is the name of the Scenario file to apply changes to. (no .csv)')
    args << scenario_file_name
       
    # mixed_type_1_percentage
    mixed_type_1_percentage = OpenStudio::Measure::OSArgument.makeDoubleArgument('mixed_type_1_percentage', true)
    mixed_type_1_percentage.setDisplayName('mixed_type_1_percentage')
    mixed_type_1_percentage.setDescription('mixed_type_1_percentage')
    mixed_type_1_percentage.setDefaultValue(0)
    args << mixed_type_1_percentage
    
    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    # assign the user inputs to variables
    scenario_file_name = runner.getStringArgumentValue('scenario_file_name', user_arguments)
    mixed_type_1_percentage = runner.getDoubleArgumentValue('mixed_type_1_percentage', user_arguments)
    
    #TODO try and get simulation_dir value
    #scenario_file_override = "#{simulation_dir}/urbanopt/scenario_file_override.json"
    scenario_file_override = "../../urbanopt/scenario_file_override.json"
    if File.exist?(scenario_file_override)
      runner.registerError("scenario_file_override File: #{scenario_file_override} already exists!")
      return false
    end

    scenario_hash = {scenario_file: scenario_file_name}
    #write_size = File.write(scenario_file_override, scenario_hash.to_json)
    write_size = File.write(scenario_file_override, JSON.pretty_generate(scenario_hash))
    if write_size >= 0
      runner.registerFinalCondition("saved scenario_file_override.json")
    else
      runner.registerWarning("saved scenario_file_override.json was size zero!")
    end    
    return true
  end
end

# register the measure to be used by the application
UrbanOptScenarios.new.registerWithApplication
