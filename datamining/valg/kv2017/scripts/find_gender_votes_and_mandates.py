#!/usr/bin/python3

import json
party_list = ["Socialdemokratiet", "Venstre", "Det Konservative Folkeparti", "Dansk Folkeparti", "SF", "Enhedslisten", "Radikale Venstre", "Liberal Alliance", "Alternativet"]

#with open('../wwwkv2017/filer/small_deep.json') as json_data:
with open('../wwwkv2017/filer/deep.json') as json_data:
    records = json.load(json_data)

    #lav object indeholdende antal mandater og stemmer fordelt på køn, parti og kommune. Medtag opstillingsform som parameter
    dict_gender_votes = {}
    for parti in party_list:
        dict_gender_votes[parti] = {}
        dict_gender_votes[parti]["male_votes"] = 0
        dict_gender_votes[parti]["female_votes"] = 0
        dict_gender_votes[parti]["mandates"] = []
        dict_gender_votes[parti]["candidates"] = []

    for record in records:
        municipalityName = record["municipalityName"]
        print(municipalityName)

        parties = record["parties"]
        for party in parties:
            partyName = party["partyName"]
            if party_list.count(partyName) == 1:
                persons = party["persons"]
                for person in persons:
                    gender = person["gender"]
                    elected = person["elected"]
                    votes = person["votes"]
                    dict_gender_votes[partyName]["candidates"].append(gender)
                    if gender == "Male":
                        dict_gender_votes[partyName]["male_votes"] = dict_gender_votes[partyName]["male_votes"] + votes
                    if gender == "Female":
                        dict_gender_votes[partyName]["female_votes"] = dict_gender_votes[partyName]["female_votes"] + votes
                    if elected == 1:
                        dict_gender_votes[partyName]["mandates"].append(gender)
#    print(dict_gender_votes)
    #loop gennem object og udskriv rapport
    party_keys = dict_gender_votes.keys()
    print( "Andelen af kvindelige kandidater - mandater - stemmetal i:")
    print( "Partinavn: kandidater - mandater - stemmetal")
    for key in party_keys:
        partyName = key
#        print(partyName)
        male_votes_count = dict_gender_votes[partyName]["male_votes"]
        female_votes_count = dict_gender_votes[partyName]["female_votes"]
        all_votes_count = female_votes_count + male_votes_count
        if all_votes_count > 0:
            female_votes_percentage = str(round((female_votes_count/all_votes_count*100), 1))

            female_candidates_count = dict_gender_votes[partyName]["candidates"].count("Female")
            all_candidates_count = len(dict_gender_votes[partyName]["candidates"])
            female_candidates_percentage = str(round((female_candidates_count/all_candidates_count*100), 1))

            female_mandates_count = dict_gender_votes[partyName]["mandates"].count("Female")
            all_mandates_count = len(dict_gender_votes[partyName]["mandates"])
            female_mandates_percentage = str(round((female_mandates_count/all_mandates_count*100), 1))

            output = partyName + ": " + female_candidates_percentage + " - " + female_mandates_percentage + " - " + female_votes_percentage
            csv_output = partyName + "," + female_candidates_percentage + "," + female_mandates_percentage + "," + female_votes_percentage
            print( csv_output)
#            print(output)
        
        
        
