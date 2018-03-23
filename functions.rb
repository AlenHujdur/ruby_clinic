require 'readline'
require 'date'

# The earliest date for which there is consistent data
DATA_START_DATE = '2006-09-20'

MAX_DAYS = 7


# Ask the user (via the command line) to provide valid start and end date

def query_user_for_date_range
  start_date = nil
  end_date = nil

  puts "\nFirst, we need a start date."
  start_date = query_user_for_date
  
  puts "\nNext, we need an end date."
  end_date = query_user_for_date

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
end
