#!/usr/bin/python3

# ;)

from datetime import datetime, timedelta
import uuid

random_uuid = uuid.uuid4()

# Define the event details
start_time = datetime(2025, 4, 16, 7, 40)  # April 10, 2025, 15:00
end_time = start_time + timedelta(hours=2)
event_title = "BNI Verslo pusryčiai"
event_description = """Mūsų BNI skyriaus nariai https://bni.lt/lt/find_a_chapter?chapterId=cqGCA2YI3IsalYCZubErIw%3D%3D"""
event_location = """
Viešbutis Šaulys, Vasario 16-osios g. 40, Šiauliai, 76351 Šiaulių m. sav.

https://maps.app.goo.gl/cMuK74vDuFqXWq6A9
"""

# Format timestamps
dtstamp = datetime.utcnow().strftime("%Y%m%dT%H%M%SZ")
dtstart = start_time.strftime("%Y%m%dT%H%M%S")
dtend = end_time.strftime("%Y%m%dT%H%M%S")

# Create the .ics content
ics_content = f"""BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//GU ICS Generatorius//LT
CALSCALE:GREGORIAN
BEGIN:VEVENT
UID:{random_uuid}
DTSTAMP:{dtstamp}
DTSTART:{dtstart}
DTEND:{dtend}
SUMMARY:{event_title}
DESCRIPTION:{event_description}
LOCATION:{event_location}
END:VEVENT
END:VCALENDAR
"""


print(ics_content)

# Save to file
# ics_file_path = "/mnt/data/sample_event.ics"
# with open(ics_file_path, "w") as file:
#     file.write(ics_content)
#
# ics_file_path
