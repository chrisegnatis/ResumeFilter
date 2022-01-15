# Resume Filter
# autors: Harsimrat Singh, John Egnatis, Vishakh Nair, Joseph Chang
# email: jce180001@utdallas.edu
# Hackreason 2022

## Inspiration
Our inspiration for the Resume Filter comes from being students knowing the struggle of looking for internships for the coming summer. Although it is impossible to judge a resume completely based off of automation, our idea is to create a program that could help companies automatically choose the most qualified candidates for an interview. Since possible thousands of applicants can be sent in every month, to receive an interview the candidate's application should score above a certain number to be considered.

## What it does
Our code is meant to be useful to a company that gets hundreds of internship applicants. Our program will look at the the parsed data from each applicant's resume and evaluate it by coming up with a score out of 100. The company, depending on the amount of applicants it receives and the number of hiring spots it has, can choose how many of the best applicants should be considered for an interview. Our program also checks for resumes that have no chance of getting accepted, like a failing GPA or having no programming experience whatsoever.


## How we built it
The program was built in Prolog which helps machines simulate human-like logic and come to conclusions. Based on research and our own experiences, we decided which parts of a resume should hold the most weight when being reviewed and created a formula to generate a number between 1 and 100. This was, if a student is poor in one aspect of their resume, they can still make up for it with the other aspects.


## Challenges we ran into
We ran into some minor challenges at the beginning with coming up with the machine's logic and translating our logic into code. Wrapping our heads around logical programming proved to be the main issue. One example is when we wanted to count how many of a student's programming languages is also valued by the company for the internship that they are applying to. We had some trouble incrementing a variable efficiently in Prolog, as standard x = x + 1 types of increments would result in infinite loops and errors, but we eventually managed to figure it out. Another challenge we had was that sCASP would only run our application in interactive mode, and it took us an hour of debugging and a mentor to find out a fix to our issue.


## Accomplishments that we're proud of
Being a group with very little experience with Prolog or any logic programming language for that matter, being able to create an application in less than 24 hours is an accomplishment for us. Our group was also put together last minute in the discord networking day, so the fact that we were all able to contribute and work together as a team made us feel accomplished.


## What we learned
We got a much better grasp on how difficult it is to actually make machines 'think,' not just from the lectures, but by figuring out how to implement our code by ourselves. We also learned how to effectively identify and tackle a problem, as our first couple brainstormed ideas fell flat when we did some research on their topics. To top it all off, we got much more comfortable with logic programming and gave us a taste of what we could accomplish in the future


## What's next for Resume Filter
Our program can still be improved upon massively to help a company decide on which applicants to choose. On top of trivial changes such as adding more parameters to consider, and going more in depth with our evaluation method, we can also help introduce a matter of subjectivity into our selection process by weighing things such as teamwork and recommendations while considering out applicants.

