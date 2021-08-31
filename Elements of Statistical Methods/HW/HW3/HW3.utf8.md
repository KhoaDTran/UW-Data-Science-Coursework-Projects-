---
title: "Stat 311, HW2"
author: "Khoa Tran"
date: "Wednesday Feb 5"
output: oilabs::lab_report
---



### Instructions
+ This homework is due on Wednesday Feb 5 by midnight. No late work is excused unless prior arrangements have been made with the instructor. The dropbox will remain open for 8 hours past the deadline. However, submissions made during this time will be penalized by at least 20% and maybe even as much as 50%.
+ Please answer ALL questions (including those that do not involve R) in the locations marked in this template. Remember to periodically **knit** your document to check that the output appears as you want it to; you will be turning in your knit html document. 
+ You will need to upload this document in CANVAS. Please be sure to check that your file was uploaded correctly. It does not hurt to screenshot verification of the upload as CANVAS can be glitchy on occasion.
+  Please answer the questions in the order in which they are posed. Write in complete sentences, and support your answers where asked. 

### Reading  (NOT OPTIONAL)
+ Sections 3.1, 3.2 in OpenIntro (4th Addition) 

* * *

### Exercise 1: Law of Large Numbers

a) According to genetic theory, there is a very close to even chance that both children in a two child family will be of the same gender. Here are two possibilities.

(i). 15 couples have two children. In 10 or more of these families, it will turn out that both children are of the same gender.

(ii). 30 couples have two children. In 20 or more of these families, it will turn out that both children are of the same gender.

Which possibility is more likely and why?

 Situation (i) is more likely.
 This is because the Law of Large Numbers stating that as there are more occurances of a specific situation, the probability of the occurance converges towards the average expected probability. With genetic theory the probability of this outcome is around 50% so the possiblity of situation (i) is more likely as 30 couples is more than 15 and as the number gets higher, the probablity converges towards 50%. 
 
b) (It might help to work through problem 5 first before you takle this question) You flip a coin a large ($n$) number of times and observe the sequence of heads and tails. The following code ``simulates'' this experiment. 


```r
n<-500     #number of students


set.seed(1234)
coin_outcomes<-c(0,0,1)
Coin_Flip<-sample(x=coin_outcomes,size=n,replace=T)

head(Coin_Flip)   
```

```
## [1] 0 0 0 1 0 0
```


(i) Calculate your *running mean* for the first 6 flips. 

   0, 0, 0, 0.25, 0.20, 0.17


(ii) In words, what does the running mean after 6 flips represent? Relate the running mean to what it tells you about the result of your coin flips.

   The running mean after 6 flips represents the proportion of heads that were flipped after 6 flips, which informs that until the 6 coin flips, the results of heads as flips was the running mean multipled by the number of coin flips.Z

(iii) Give the number that the sequence of running means will *converge* (get close) to as $n$ increases? 

   As the number of n increases, the sequence of running means will converge towards 0.33.


### Exercise 2: Calculating Probabilities

 Citrus trees are grown in ordered arrangements. A small [plot](https://drive.google.com/open?id=1KKPRdFzQweZm2vp3fcfQIKy-ogBpk8vw) has 3 rows with 3 trees in it as shown below. Each random experiment below has a sample space with equally likely outcomes. Describe the sample space, in particular, how many outcomes? Then use the ones favorable to the event of interest and calculate probabilities. 
	
a) A sample of 3 trees is obtained by choosing a row at random and then taking all 3 trees in that row. Calculate the probability that the tree labeled "1" will be selected under this sampling scheme? 

  P(Picking row with tree 1) = 1/3
  The sample space S = {Row 1, Row 2, Row 3}. The sample space, S, has one event that is favorable with 3 possible outcomes.
 
         
b) A sample of 3 trees is obtained by randomly selecting a tree from each row. Calculate the probability that the tree labeled "1" will be selected under this sampling scheme. Highlight your final numerical answer. 

  P(Picking tree 1) = (Probability of picking tree 1 from Row 1) + (Probability of picking tree 1 from Row 2) + (Probability of picking tree 1 from Row 3) = 1/3 + 0 + 0 = $1/3$.
  The sample space S = {(1, 4, 7), (1, 4, 8), (1, 4, 9), (1, 5, 7), (1, 5, 8), (1, 5, 9), (1, 6, 7), (1, 6, 8), (1, 6, 9), (2, 4, 7), (2, 4, 8), (2, 4, 9), (2, 5, 7), (2, 5, 8), (2, 5, 9), (2, 6, 7), (2, 6, 8), (2, 6, 9), (3, 4, 7), (3, 4, 8), (3, 4, 9), (3, 5, 7), (3, 5, 8), (3, 5, 9), (3, 6, 7), (3, 6, 8), (3, 6, 9)}. The sample space S has 9 favorable events with 27 possible outcomes.
 
        
c) A sample of 3 trees is obtained by first randomly choosing a starting tree (call it $start$) from 1, 2, 3. Every third tree thereafter is selected. For example, if $start=2$, then trees 2, 5 and 8 are selected. What is the probability that the tree labeled "1" will be selected under this sampling scheme. 

  P(tree 1 selected) = P(tree 1 picked at start) = 1/3
  The sample space S is = {(1, 4, 7), (2, 5, 8), (3, 6, 9)}. The sample space S has 1 favorable event with 3 possible outcomes. 
         
d) The trees 3, 6 and 9 are easily accessible as they are right by a path and are chosen to be the sample. Can we calculate probabilities in this setting? Why or why not?
        
  Yes, you could calculate the probabilities in this setting even when knowing the sample that is chosen because you can always calculate the probablity of a set not being in the sample compared with the probability that 3, 6, and 9 are in the sample. Since the values are set, there is no chance for picking other numbers, but it is still a valid probability.
         
         
         
### Exercise 3: Probability Distributions

A box contains 100 marbles, some of which are red and the rest blue. A sample of 10 marbles is taken randomly (with replacement) from the box and the statistic: number of red marbles in the sample is calculated. 
 
 The probability model for this statistic is shown below. (Note: the probabilities should add to 1 -- any difference from 1 is due to round-off errors.)
 
|   values | probability (%) | 
|:--------:|  :----          |
|  0    |  0.6047         |
|	 1     |  4.0311         |  
|  2    | 12.0932         |
|  3   | 21.4991         |
|	 4     | 25.0823         |
|  5      | 20.0658         |
|	 6     | 11.1477         |
|  7   |  4.2467         |
| 8   |  1.0617         |
| 9   |  0.1573         |
|  10   |  0.0105         |
 
 a) Roughly, what is the shape of the probability model?
 	
  	The shape of the probability model is a bit right skew.
 	
 b) Calculate the center (mean) of the probability model.
 
   The mean of the porbablity model is 4.000004.
  

```r
  mean = (0 * 0.006047 + 1 * 0.040311 + 2 * 0.120932 +  3 * 0.214991 + 4  * 0.250823  + 5 * .200658 + 6 * 0.111477  + 7 * 0.042467  +  8 * 0.010617 + 9  * 0.001573  + 10 * 0.000105)
  mean  
```

```
## [1] 4.000004
```
  
 c) Argue that 1.5 is a good guess for the standard deviation of the probability model. 
 
   1.5 is a good guess for the standard deviation of the probability model because if you take the calculated mean, rounded to 4.00, then (4.00 - 1.50) = 2.50 and (4.00 + 1.50) = 5.50. Since the range of 2.5 and 5.5 represents the number of marbles that are red, it is more realistic to look at the range of 3.0 to 6.0 and since 77% of the data lies within one standard deviation of 1.5, this makes it a good guess. Of course, the ideal number is 68%, but since it is a guess and it falls around the ideal %, this makes 1.5 a good guess for the standard deviation.
 
 d) Suppose you repeat the experiment of sampling 10 randomly with replacement $n$ times. Each time, you calculate the number of red marbles in your sample. Suppose you were to make a plot of the running means of the results, what would happen as $n$ increases? Any guess on what the running means would converge to? 
 
  My guess is that the plot of the running mean would straighten out, and converge to the expected probability as n increases, which would be 0.4 as we expect 4/10 marbles to be red.
   
### Exercise 4:  Conditional Probability

a) Suppose that 30% of computer owners use a Macintosh, 50% use Windows and 20% use Linux. Suppose that 65% of Mac users have succumbed to a virus, 82% of the Window users get the virus and 50% of the Linux users get the virus. We select a person at random and learn that her computer is infected with a virus. What is the probability that she is a Windows user?

  The probability that she is a Windows user is 58.2%.
  We can look at the conditional probability, which is what is the probablity of the user having a Windows and given the condition that she has a virus. This means we would want to use the conditional probablity, which is P(A and B)/P(B), which is probability of user having Windows and probability of user having a virus divided by probability of user having a virus. So, (0.5 * 0.82) / (0.3 x 0.65 + 0.5 x 0.82 + 0.2 x 0.5) which results in 0.582 rounded to 58%.

b) There are three cards. One is green on both sides, the second is red on both sides and the third is red on one side and green on the other. We choose a card at random and we see one side (also chosen at random). If the side we see is green, what is the probability that the other side is also green? Many people intuitively answer 1/2 but this is not the correct answer.  (Hint: Label one side of each card as 1 and the other as 2. An outcome is then $(x,y)$ where $x$ is the color and $y$ is the side of the card we see.)

  The probablity of the other side also being green is 2/3.
  From the conditional probability, where the focus is at the probability of flip side being green given the current side is green. So we do P(Green | Green) = P(Green & Green) / P(1 Green side), where we know that only 1/3 of cards have both sides as green and 3/6 sides sides being green in total. So simiplied to (1/3)/(1/2) = 2/3, which is the conditional probability of the green card having it's back also being green. 


### Exercise 5: Law of Large Numbers: R problem

In this question, you will use the simulation skills you learned in the lab to explore the consequences of the Law of Large Numbers.  The Law says that if we continue tossing a fair coin (say) for more and more tosses, we should get closer and closer to seeing ``heads`` 50% of the time. 

People generally interpret this statement as saying that the number of times that we see heads gets closer to half the number of flips. 

We will see through the simulations below that this is an incorrect interpretation of the Law of Large Numbers. It is the *proportion* of times that we see heads and not the *number* of times we see heads that that is being spoken about in the Law.  

One simple trick will make our lives easier in this problem. Instead of working with ``heads`` and ``tails`` as our coin outcomes, lets use `1` to denote ``heads`` and `0` to denote ``tails``. This will allow us to apply mathematical operations to our simulation results. 


### Part A 

Consider the following code.


```r
set.seed(400)
coin_outcomes <- c(0,1)
simulation_results <- sample(coin_outcomes, size=50, replace=TRUE)
simulation_results %>% sum()
```

```
## [1] 27
```

```r
simulation_results %>% mean()
```

```
## [1] 0.54
```

Recalling that `1` is heads and `0` is tails, how would you interpret the sum of the simulation results? How would you interpret the mean of the simulation results? Note that your interpretations should **not** use the words `sum` and `mean`. Also note that it may be helpful to pick a random seed; otherwise your answer will change each time you knit the document (but this question is not looking for a "correct" number of heads, so you may pick whatever seed you would like.) 

My interpretation of the results includes the first results being 27 heads in this sample set, and the size of the experiment is 50 - 27 = 23, which is the numbers of tails flipped in this set. The second result would be the proportion of heads that were flipped out of the total runs in the sample set of 50 times, which means that 54% of the sample runs came out as heads. 

### Part B

Let's explore what happens to the sum of the simulation results as the number of flips gets bigger and bigger. We can simulate 10000 flips, and then we can compute a **cumulative sum** (or running sum) using ``cumsum()``. 


```r
set.seed(311)
tosses = sample(coin_outcomes, size = 10000, replace=TRUE)
sum_so_far = cumsum(tosses)
```

Explore the ``sum_so_far`` object. The first element tells us our total sum after 1 flip. The second element tells us our total sum after 2 flips. The third element tells us our total sum after 3 flips, etc. Print out the 277th element of your ``sum_so_far`` object and interpret its value. What would you *expect* the sum to be after 277 flips? How far is your observed value from the expected value?
 


```r
sum_so_far[277]
```

```
## [1] 128
```
  The value of the 277th value in the sum_so_far table is 128. This value can be intepreted as the total heads after the 277 flips in the experiment run. The sum expected to see is 138 but the observed valued is 10 heads flips less than the expected value. 
### Part C

Now let's create an object called ``mean_so_far``, where element $i$ tells us the average result after $i$ flips. Note that ``(1:10000)`` simply creates a vector storing ``[1,2,3,4,....,10000]``, and R does element-by-element division. 


```r
mean_so_far = sum_so_far/(1:10000)
```

Explore the ``mean_so_far`` object. Print out the 112th element and interpret its value. Think about what you would *expect* the mean to be after 112 flips. How far is your observed value from the expected value?


```r
mean_so_far[112]
```

```
## [1] 0.3839286
```
The 112th element is the mean_so_far object gives a value of 0.38 as the proportion of heads that have been flipped by the 112th run in the experiement. We expect this value to be closer to 0.50 but the observed value is 0.12 less than the expected result by the 112th run in the experiment. 

### Part D
Let's visually explore the results using ``ggplot``. In order to use the ``ggplot`` syntax that you are used to, it will be useful to store all of the information you have so far in a dataframe. 


```r
coin_tosses <- data.frame(n=1:10000, expected_sum_so_far = 1:10000/2, 
                          sum_so_far = sum_so_far,
                          mean_so_far = mean_so_far, 
                          expected_mean_so_far = 0.5)
head(coin_tosses)
```

```
##   n expected_sum_so_far sum_so_far mean_so_far expected_mean_so_far
## 1 1                 0.5          0   0.0000000                  0.5
## 2 2                 1.0          1   0.5000000                  0.5
## 3 3                 1.5          1   0.3333333                  0.5
## 4 4                 2.0          1   0.2500000                  0.5
## 5 5                 2.5          2   0.4000000                  0.5
## 6 6                 3.0          2   0.3333333                  0.5
```

Using the new ``coin_tosses`` dataframe, make a plot using ``geom_point()`` where the x-axis is `n` (number of flips) and the y-axis is `sum_so_far - expected_sum_so_far`. You may mutate the dataframe to add the difference if you wish, or you can type the subtraction expression directly into ``ggplot``.

Does this plot relate to the number of heads or the proportion of heads?


```r
ggplot(coin_tosses, aes(x = n, y = sum_so_far - expected_sum_so_far)) + geom_point()
```

<img src="HW3_files/figure-html/unnamed-chunk-9-1.png" width="672" />
  This plot relates to the number of heads as we are using the sum variable, which keeps count of how many heads we have in total up to a specific run count.

### Part E

Repeat part D, but now have the Y-axis be `mean_so_far - expected_mean_so_far`. 

Does this plot relate to the number of heads or the proportion of heads?


```r
ggplot(coin_tosses, aes(x = n, y = mean_so_far - expected_mean_so_far)) + geom_point()
```

<img src="HW3_files/figure-html/unnamed-chunk-10-1.png" width="672" />
This plot relates to the proportion of heads, as it looks at the mean up towards the run count, which is proportion of heads until a specific run count. 

### Part F

Explore what happens if you change the random seed used to create ``tosses`` and repeat the analysis. Of the plots in part D and E (sum or mean), which one is more consistent when the random seed changes? We have provided a code chunk below for you to efficiently explore the results. You do not need to include the output of multiple random seeds in your submission, but you should include a description of what you learned from changing the random seeds. 


```r
set.seed(1500)
new_tosses = sample(coin_outcomes, size = 10000, replace=TRUE)
new_coin_tosses <- data.frame(n=1:10000, expected_sum_so_far = 1:10000/2, 
                              sum_so_far = cumsum(new_tosses), mean_so_far = cumsum(new_tosses)/(1:10000), expected_mean_so_far = 0.5)
ggplot(new_coin_tosses, aes(x = n, y = sum_so_far - expected_sum_so_far)) + geom_point()
```

<img src="HW3_files/figure-html/unnamed-chunk-11-1.png" width="672" />

```r
ggplot(new_coin_tosses, aes(x = n, y = mean_so_far - expected_mean_so_far)) + geom_point()
```

<img src="HW3_files/figure-html/unnamed-chunk-11-2.png" width="672" />
With changing the seed multiple times, I saw that the mean difference graph doesn't change no matter the seed but the difference of the sum of heads graph is different with changing seeds. I learned that from the Law of Large Numbers, as we increase n, the proportion will converge towards the expected amount, no matter the seed that is set. However, the sum and the difference between the expected sum graph will change depending on the seed because as n increases, it counters the difference in sum at the beginning with a low number of runs. As a result, the proportion difference between expected and observed goes towards 0 because with the number of trials increased, the proportion will converge towards 50% with a difference of zero with the expected. 
