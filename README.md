# C-Change
John Zhou's Working Document in Brandeis WSRC C-Change
# 1. Download data 
from NIH database& NIH Reporter: https://projectreporter.nih.gov/reporter.cfm and TAGGS https://taggs.hhs.gov/
2016-2019 R01, 2013-2016 R21,all historical R34,Ks Grant
# 2. R Code on data processing
Split researcher in same project(we ant resercher not project).  First and only R01,R21,R34,Ks in 2016-2019, exclude insitution such as small business grant, medical companies
Non-exact match on teching hospital and medical school names.
# 3. Export data with selection
Apply unique() to get excluded institution manually work with director to finish the candidate filter.
# 4. Merge all grant together
# 5. Scrape personal information by Python(Photo, Linkedin Information, Official Website Contact)
# 6. Applied Kairos API to identify candidate's Gender/Race/Age
