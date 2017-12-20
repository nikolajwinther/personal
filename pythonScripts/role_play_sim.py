#!/usr/bin/python3

import random

def count_random_numbers(sample_size, dice_size):
    '''
    (number, number) --> dict
    This function emulates dice throws, and sorts the result into  
    different categories
    '''
    output = {}
    #keys = ['fail', 'crit_plus', 'crit_fail', 'alls', 'succes', 'rest']

    #Creating list for the categories
    alls = []
    crit_plus = []
    crit_fail = []
    fail = []
    rest = []
    succes = []

    for i in range(sample_size):
        #print(i, "from sample size:", sample_size) #To keep track of script in the shell
        random_int = random.randint(1, dice_size)
        alls.append(random_int)

    alls.sort()
    for integer in alls:
        if integer < 10:
            fail.append(integer)
            if integer < 2:
                crit_fail.append(integer)
            if str(integer)[-1] == '5':
                crit_plus.append(integer)
        elif integer > 90:
            succes.append(integer)
            if str(integer)[-1] == '5':
                crit_plus.append(integer)
        elif str(integer)[-1] == '5':
            crit_plus.append(integer)
        else:
            rest.append(integer)

    output['1 alls'] = alls
    output['2 fail'] = fail
    output['3 succes'] = succes
    output['4 crit_fail'] = crit_fail
    output['5 crit_plus'] = crit_plus
    output['6 rest'] = rest
    
    return output

def main():
    #Set sample size and dice size here:
    sample_sizes = [200]
    dice_size = 100

    samples = []
    for size in sample_sizes:
        samples.append(count_random_numbers(size, dice_size))

    for sample in samples:
        print(sample['1 alls'])
        keys = list(sample.keys())
        keys.sort()
        for key in keys:
            print(key, len(sample[key]))

if __name__ == "__main__":
    main()

