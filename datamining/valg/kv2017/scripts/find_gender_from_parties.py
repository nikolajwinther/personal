#!/usr/bin/python3

import json

def find_gender_for_candidated( partyName):
    '''
    (string) --> dict
    This function loops through all municipalities and counts the number of 
    male and female candidates
    '''
    with open('../wwwkv2017/filer/deep.json') as json_data:
        records = json.load(json_data)
    #    #Fremfinding af kommuner uden kvinder på Alternativets kandidatliste
        party_dict = {}
        for record in records:
            #output = record["municipalityName"] # + "," + record["electionTurnout"] + "," + record["tax"]
            municipalityName = record["municipalityName"]
            parties = record["parties"]
            for party in parties:
                if party["partyName"] == partyName:
                    party_dict[municipalityName] = {}
                    all_count = len(party["persons"])
                    female_count = 0
                    for person in party["persons"]:
                        if person["gender"] == "Female":
                            female_count = female_count + 1
                    party_dict[municipalityName]["all_count"] = all_count
                    party_dict[municipalityName]["female_count"] = female_count
        return party_dict



party_list = ["Socialdemokratiet", "Venstre", "Det Konservative Folkeparti", "Dansk Folkeparti", "SF", "Enhedslisten", "Radikale Venstre", "Liberal Alliance", "Alternativet", "Kristendemokraterne"]
for party in party_list:
    party_dict = find_gender_for_candidated(party)
    party_keys = party_dict.keys()
    print(party)
#    #Dette loop printer antallet af kvinder på stemmesedlen (og det samlede antal)
#    for key in party_keys:
#        output = str(party_dict[key]["female_count"]) + " " + str(party_dict[key]["all_count"]) + " " + key 
#        print(output)
#    #Dette loop printer kun de steder hvor der ikke er nogen kvinder
#    for key in party_keys:
#        if party_dict[key]["female_count"] == 0:
#            output = str(party_dict[key]["female_count"]) + " " + str(party_dict[key]["all_count"]) + " " + key 
#            print(output)
    #Dette loop printer kun de steder hvor der ikke er nogen mænd
    for key in party_keys:
        if party_dict[key]["female_count"] == party_dict[key]["all_count"]:
            output = str(party_dict[key]["female_count"]) + " " + str(party_dict[key]["all_count"]) + " " + key 
            print(output)
    print("")        




