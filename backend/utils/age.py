from datetime import date
from dateutil import parser
from dateutil.relativedelta import relativedelta

def calculate_age(date_of_birth):
  current_date = date.today()
  dob = parser.parse(date_of_birth).date()
  age = relativedelta(current_date, dob).years
  return age
