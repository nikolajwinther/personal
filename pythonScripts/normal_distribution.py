#!/usr/bin/python

import random
import plotly
import plotly.plotly as py
import plotly.graph_objs as go

def count_random_numbers(sample_size, dice_size):
    '''
    (number, number) --> dict
    This function emulates dice throws, and counts how many times each
    side is represented in the sample.
    '''
    list_count = []
    for i in range(sample_size):
        list_numbers = []
        for j in range(dice_size**2):
            random_int = random.randint(1,dice_size)
            print random_int
            list_numbers.append(random_int)
        for j in range(1, dice_size + 1):
            count = list_numbers.count(j)
            list_count.append(count)

    list_count.sort()
    uniq_list = list(set(list_count))
    uniq_list.sort()
    output = {}
    output['numbers'] = uniq_list
    output['amount'] = []
    output['sample_name'] = "Sample size " + str(sample_size)
    numbers = []
    for number in uniq_list:
        amount = list_count.count(number)
        output['amount'].append(amount)

    return output

#Set sample size and dice size here:
sample_sizes = [100, 200]
dice_size = 100
samples = []
for sample_size in sample_sizes:
    samples.append(count_random_numbers(sample_size, dice_size))
print samples

data = []
for sample in samples:
    trace = go.Scatter(
        x = sample['numbers'],
        y = sample['amount'],
        mode = 'lines',
        name = sample['sample_name']
    )
    data.append(trace)

plotly_filename = "Norm-dist-with-" + str(dice_size) + "-side-dice-v1"
py.iplot(data, filename=plotly_filename)


