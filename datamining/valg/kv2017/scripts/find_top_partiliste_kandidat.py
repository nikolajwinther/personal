#!/usr/bin/python3

import json

with open('../wwwkv2017/filer/deep.json') as json_data:
    records = json.load(json_data)
    #find kandidater med flere personlige stemmer end partikolleger men som alligevel ikke blev valgt.
    dict_popular_unelected = {}
    for record in records:
        municipalityName = record["municipalityName"]
        dict_popular_unelected[municipalityName] = {}

        parties = record["parties"]
        for party in parties:
            partyName = party["partyName"]
#            print(party["electionSystem"])
            if partyName == "Liberal Alliance":
#                if party["electionSystem"] == "Partiliste opstillingsform":
                first_person = party["persons"][0]
    #            output = 
#                print(first_person["gender"])
                print(first_person["name"] + " - " + first_person["gender"])



#                output_dict = {}
#                for i in range(99):
#                    output_dict[str(i)] = []

#                for i in range(party["persons"]):
#                    if party["electionSystem"] == "Partiliste opstillingsform":
#                        first_person = party["persons"][i]
#                        first_person_gender = first_person["gender"]
#                        output_dict[str(i)].append(first_person_gender)
#                        print(first_person["gender"])
# 29, 41, 35, 50
