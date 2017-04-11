module DataLocations
  ENROLLMENT = {
    DROPOUT_RATES = "./data/"
  }
end

class DataInput

  # Enrollment
  DROPOUT_RATES = "Dropout rates by race and ethnicity.csv"
  GRADUATION_RATES = "High school graduation rates.csv"
  KINDERGARTEN = "Kindergartners in full-day program.csv"
  ONLINE_PUPIL_ENROLLMENT = "Online pupil enrollment.csv"
  PUPIL_ENROLLMENT_BY_RACE = "Pupil enrollment by race_ethnicity.csv"
  PUPIL_ENROLLMENT = "Pupil enrollment.csv"
  SPECIAL_ED = "Special education.csv"
  REMEDIATION = "Remediation in higher education.csv"

  # Statewide Testing
  THIRD_GRADE_TESTING = "3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
  EIGHTH_GRADE_TESTING = "8th grade students scoring proficient or above on the CSAP_TCAP.csv"
  MATH_PROFICIENCY_BY_RACE = "Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv"
  READING_PROFICIENCY_BY_RACE = "Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv"
  WRITING_PROFICIENCY_BY_RACE = "Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"

  # Economic Profile
  MEDIAN_INCOME = "Median household income.csv"
  CHILDREN_IN_POVERTY = "School-aged children in poverty.csv"
  REDUCED_LUNCH = "Students qualifying for free or reduced price lunch.csv"
  TITLE_1 = "Title I students.csv"
end
