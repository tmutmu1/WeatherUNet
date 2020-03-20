import matplotlib.pyplot as plt
import numpy as np

def plot_img_array(img_array, ncol=3):
    #for i in range(len(img_array)):
    nrow = len(img_array) // ncol
    #nrow = len(img_array[i])

    f, plots = plt.subplots(nrow, ncol, sharex='all', sharey='all', figsize=(ncol * 4, nrow * 4))
    #print(plots[0])
    for j in range(len(img_array)):
    #for j in range(len(img_array[i])):
    #lots[j // ncol, j % ncol]
        plots[j // ncol, j % ncol].imshow(img_array[j])
        #plots[0, j]
        #plots[j, i].imshow(img_array[i][j])

from functools import reduce
def plot_side_by_side(img_arrays):
    flatten_list = reduce(lambda x,y: x+y, zip(*img_arrays))

    #print(np.array(flatten_list).shape)
    #print(np.array(flatten_list)[0].shape)
    #print(np.array(flatten_list)[0][0][0])
    """print(np.array(img_arrays).shape)
    print(np.array(img_arrays)[0].shape)
    print(np.array(img_arrays)[2][0][0][0])"""
    plot_img_array(np.array(flatten_list), ncol=len(img_arrays))

import itertools
def plot_errors(results_dict, title):
    markers = itertools.cycle(('+', 'x', 'o'))

    plt.title('{}'.format(title))

    for label, result in sorted(results_dict.items()):
        plt.plot(result, marker=next(markers), label=label)
        plt.ylabel('dice_coef')
        plt.xlabel('epoch')
        plt.legend(loc=3, bbox_to_anchor=(1, 0))

    plt.show()

def masks_to_colorimg(masks):
    colors = np.asarray([(201, 58, 64), (242, 207, 1), (0, 152, 75)])#, (101, 172, 228),(56, 34, 132), (160, 194, 56)])

    colorimg = np.zeros((masks.shape[1], masks.shape[2], 3), dtype=np.float32)# * 255

    channels, height, width = masks.shape

    for y in range(height):
        for x in range(width):
            for i in range(3):
                #selected_colors = colors[masks[:,y,x] > 0.5]
                #selected_colors = colors[masks[:,y,x] > 0.25]
                #colorimg[y][x][i] = masks[i][y][x] * 255
                #colorimg[y][x][i] = np.rint(masks[i][y][x]*4.0)*(255/4)
                if (0 <= masks[i][y][x] < 1):
                    colorimg[y][x][i]=0
                elif (1 <= masks[i][y][x] < 2):
                    colorimg[y][x][i]=255/2
                elif (2 <= masks[i][y][x] <= 3):
                    colorimg[y][x][i]=255
                else:
                    print("This should never happen: ", masks[i][y][x])
               # if len(selected_colors) > 0
                   # colorimg[y,x,:] = np.mean(selected_colors, axis=0)
    #print(colorimg[0][0])
    return colorimg.astype(np.uint8)