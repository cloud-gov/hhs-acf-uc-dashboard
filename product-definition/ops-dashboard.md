# Ops Dashboard - which is the place all the calculations happen
This is about where the data comes from and what the calculations imply

There is a new UAC_ID for the same child any time a child is admitted
When the DATE_ORR_APPROVED changes so does the id, for a given person

C-15 Referred Placement
Daily placements. Intakes team has daily sheet with this information fill in colums a-i

Portal: intakes tab
Column h is daily trends

Status is enroute, that is the same as placement made.
Children in intake that have the enroute current uac status

Query
filter orr placement date for current date
and in route
count for that query

placement date, orr approved

UAC_ID is unique id
deduped and empty removed

C-16 Discharges

Both
UAC_STATUS discharged
CURRENT_STATUS discharged
And a given date
Then deduped

E-15 In care

Current CENSUS:

In the daily, column i
UAC_STATUS = ADMITTED, ENROUTE, IN-TRANSFER

Dedup is by UAC_ID and DATE_ORR_APPROVED

ALIEN_NUMBER is given by DHS/ICE officer, attempts to give a unique number per kid. But there are many human errors that misidentify.

E-16 Open beds

comes from current funded capacity - in care.

E-17 Reserve beds

E-19 Current occupancy rate

E-20 Including reserved beds

E-22 Discharge rate, 7 days

E-23 Discharge rate, 30 days

E-25 85% capacity

E-26 96% capacity

E-29 Referred placement

E-30 Referred placement, average 7 days

E-31 Referred placement, last month

E-32 Discharges


E-33 Discharges, average 7 days

E-34 Discharges, last month

E-35 Current census

E-36 Current census, average 7 days

E-37 Current census, last month

E-38

Total funded capacity:
Funded capacity is hard coded.
8717, standard beds
+ temporary shelters
+ variance

Intake:
Confirms

Funded capacity: (standard shelter beds)
Unavailable: (can't be manned in standard shelter, stop placement, quarantine, etc)
Activated beds:

column N funded capacity without reserved

Activated beds:
column ? reserved beds


Temporary shelter number
Variance shelter number

Capacity management tab:
Has funded capacity total
Does not recognize on reserve, but not activated

Holloman has 655 beds on reserve. Not being used, need 30 days for activation.

The portal has no real notion of standard beds vs reserved. So the number is wrong

--------

Confirmation process happens via admin daily. No one can see current day before this confirmation by an admin
