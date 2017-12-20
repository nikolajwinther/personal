#!/usr/bin/python3

import json
#municipality_numbers = ["101", "147", "151", "153", "155", "157", "159", "161", "163", "165", "167", "169", "173", "175", "183", "185", "187", "190", "201", "210", "217", "219", "223", "230", "240", "250", "253", "259", "260", "265", "269", "270", "306", "316", "320", "326", "329", "330", "336", "340", "350", "360", "370", "376", "390", "400", "410", "420", "430", "440", "450", "461", "479", "480", "482", "492", "510", "530", "540", "550", "561", "563", "573", "575", "580", "607", "615", "621", "630", "657", "661", "665", "671", "706", "707", "710", "727", "730", "740", "741", "746", "751", "756", "760", "766", "773", "779", "787", "791", "810", "813", "820", "825", "840", "846", "849", "851", "860"]

#new_list = []
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

            persons = party["persons"]
            dict_popular_unelected[municipalityName][partyName] = {
                "elected": [],
                "electedVotes": [],
                "notElected": [],
                "notElectedVotes": []
            }
            elected_votes_list = dict_popular_unelected[municipalityName][partyName]["electedVotes"]
            not_elected_votes_list = dict_popular_unelected[municipalityName][partyName]["notElectedVotes"]

            for person in persons:
                votes = person["votes"]
                if person["elected"] == 1:
                        elected_votes_list.append(votes)
                if person["elected"] == 0:
                        not_elected_votes_list.append(votes)
            elected_votes_list.sort()
            elected_votes_list.reverse()
            not_elected_votes_list.sort()

            votes_list = []
            while (len(elected_votes_list) and len(not_elected_votes_list)) > 0 and (not_elected_votes_list[-1] > elected_votes_list[-1]):
                if len(elected_votes_list) > 0:
                    votes_list.append(elected_votes_list[-1])
                    elected_votes_list.pop()
                if len(not_elected_votes_list) >0:
                    votes_list.append(not_elected_votes_list[-1])
                    not_elected_votes_list.pop()

            for vote in votes_list:
                for person in persons:
                    votes = person["votes"]
                    is_elected = person["elected"]
                    if vote == votes:
                        if is_elected == 1:
                            dict_popular_unelected[municipalityName][partyName]["elected"].append(person)
                        else:
                            dict_popular_unelected[municipalityName][partyName]["notElected"].append(person)


    #print listen af kandidater med højere stemmetal end valgte partikolleger samt de(n) politiker(e) der blev valgt
    municipality_keys = dict_popular_unelected.keys()
    for municipality_key in municipality_keys:
        party_keys = dict_popular_unelected[municipality_key]
        for party_key in party_keys:
            not_elected_list = dict_popular_unelected[municipality_key][party_key]["notElected"]
            elected_list = dict_popular_unelected[municipality_key][party_key]["elected"]
            if len(not_elected_list) > 0:
                for not_elected in not_elected_list:
                    output = "Not elected; " + not_elected["name"]  + "; " + not_elected["gender"] + "; " + party_key + "; " + municipality_key + "; " + str(not_elected["votes"])
                    print(output)
#                    print(str(not_elected["votes"]))
                for elected in elected_list:
                    output = "Elected; " + elected["name"]  + "; " + elected["gender"] + "; " + party_key + "; " + municipality_key + "; " + str(elected["votes"])
                    print(output)
                print("")



