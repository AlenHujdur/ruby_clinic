require 'readline'
require 'date'
require 'open-uri'

# The earliest date for which there is consistent data
DATA_START_DATE = '2006-09-20'

MAX_DAYS = 7

READING_TYPES = {
  "Wind_Speed" => "Wind Speed"
  "Air_Temp" => "Air Temp",
  "Barometric_Press" => "Pressure"
}

# Ask the user (via the command line) to provide valid start and end date

def query_user_for_date_range
  start_date = nil
  end_date = nil

  until start_date && end_date
    puts "\nFirst, we need a start date."
    start_date = query_user_for_date
  
    puts "\nNext, we need an end date."
    end_date = query_user_for_date
    if !date_range_valid?(start_date, end_date)
      puts "Let's try again."
      start_date = end_date = nil
    end
  return start_date, end_date
end

# Ask the user (via the command line) for a single valid date.
# Used for both start and end dates.

def query_user_for_date
  date = nil
  until date.is_a? Date
    prompt = "Please enter a date as YYYY-MM-DD: "
    response = Readline.readline(prompt, true)
  
    # We have the option to quit at any time.
    exit if ['quit', 'exut','q','x'].include?(response)

    begin
      date = Date.parse(response)
    rescue
      puts "\nInvalid date format."
    end
    date = nil unless date_valid?(date) #unless -> if not

  end
  return date
end

# Test if a single date is valid
def date_valid?(date)
  valid_dates = Date.parse(DATA_START_DATE)..Date.today
  if valid_dates.cover?(date)
    return true
  else
    puts "nDate must be after #{DATA_START_DATE} and before today."
    return false
  end
end

# Test if a range of dates is valid
def date_range_valid?(start_date, end_date)
  if start_date > end_date
    puts "\nStart date must be before end date."
    return false
  elseif start_date + MAX_DAYS < end_date
    puts "\nNo more than #{MAX_DAYS} days. Be kind to remote server"
    return false
  end
  return true
end

### Retrieve remote data ###

def get_readings_from_remote_for_dates(type, start_date, end_date)
  readings = []
  start_date.upto(end_date) do |date|
    readings += get_readings_from_remote(type, date)
  end
  return readings
  end
end

def get_readings_from_remote(type, date)
  raise "Invalid Reading Type" unless
READING_TYPES.keys.include?(type)

  # read the remote file, split readings into an array
  base_url = "https://lpo.dt.navy.mil/data/DM"
  url = "#{base_url}/#{date.year}/#{date.strtime("%Y_%m_%d")}/#{type}"
  puts "Retrieving: #{url}"
  data = open(url).readlines

  # Extract the reading from each line
  # "2014_01_01 00:02:57  7.6\r\n" becomes 7.6
  readings = data.map do |line|
    line_items = line.chomp.split(" ")
    reading = line_items[2].to_f
  end
  return readings
end
end




