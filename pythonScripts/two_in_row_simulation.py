#!/usr/bin/python

import random
import plotly
import plotly.plotly as py
import plotly.graph_objs as go

def count_random_numbers(sample_size, dice_size):
    '''
    (number, number) --> dict
    This function emulates dice throws, and counts how many times it 
    takes before a the same number is thrown in a row
    '''
    arr_count = []
    for i in range(sample_size):
        print i, "from sample size:", sample_size #To keep track of script in the shell
        arr = [0]
        while True:
            random_int = random.randint(1,dice_size)
            if arr[-1] != random_int:
                arr.append(random_int)
            else:
                arr_length = len(arr) - 1
                arr_count.append(arr_length)
                break
    arr_count.sort()
    output = {}
    output['numbers'] = []
    output['counts'] = []
    output['sample_name'] = "Sample size " + str(sample_size)
    for number in range(2, arr_count[-1] + 1):
        count = arr_count.count(number)
        output['numbers'].append(number)
        output['counts'].append(count)

    return output

#Set sample size and dice size here:
sample_sizes = [50000, 100000, 500000, 1000000]
dice_size = 100

samples = []
for size in sample_sizes:
    samples.append(count_random_numbers(size, dice_size))

data = []
for sample in samples:
    trace = go.Scatter(
        x = sample['numbers'],
        y = sample['counts'],
        mode = 'lines',
        name = sample['sample_name']
    )
    data.append(trace)

plotly_filename = "Throw-two-consec-" + str(dice_size) + "-side-dice-v0"
py.iplot(data, filename=plotly_filename)

