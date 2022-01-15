# ResumeFilter
Project for 2022 Hackreason 

Inspiration:
Our inspiration

What It Does:
Our code is meant to be useful to a company that gets hundreds of internship applicants. Our program will look at the the parsed data from each applicant's resume and evauluate it by coming up with a score out of 100. The company, depending on the amount of applicants it recieves and the number of hiring spots it has, can choose how many of the best applicants should be considered for an interview. Our program also checks for resumes that have no chance of getting accepted, like a failing GPA or having no programming experience whatsoever.

How We Built It:
The program was built in Prolog which helps machines simulate human-like logic and come to conclusions. Based on research and our own experiences, we decided which parts of a resume should hold the most weight when being reviewed and created a formula to generate a number between 1 and 100. This was, if a student is poor in one aspect of their resume, they can still make up for it with the other aspects.

Challenges We Ran Into:
We ran into some minor challenges at the beginning with coming up with the machine's logic and translating our logic into code. Wrapping our heads around logical programming proved to be the main issue. One example is when we wanted to count how many of a student's programming languages is also valued by the company for the internship that they are applying to. We had some trouble incrementing a variable efficiently in Prolog, as standard x = x + 1 types of increments would result in infinite loops and errors, but we eventually managed to figure it out.

Accomplishments We Are Proud Of:

What We Learned:
We got a much better grasp on how difficult it is to actually make machines 'think,' not just from the lecutres, but by figuring out how to implement our code by ourselves. We also learned how to effectively identify and tackle a problem, as our first couple brainstormed ideas fell flat when we did some research on their topics. To top it all off, we got much more comfortable with logic programming and gave us a taste of what we could accomplish in the future

What's Next For Resume Filter:
Our program can still be improved upon massively to help a company decide on which applicants to choose. On top of trivial changes such as adding more parameters to consider, and going more in depth with our evaluation method, we can also help introduce a matter of subjectivity into our selection process by weighing things such as teamwork and recommendations while considering out applicants.
