% Checks what type of degree a student had, since a higher level degree is weighted more heavily

schoolMetric(Degree, Score) :- 
    Degree = bach, 
    Score is 12.
schoolMetric(Degree, Score) :- 
    Degree = masters, 
    Score is 15.
schoolMetric(Degree, Score) :- 
    Degree = phd, 
    Score is 15.

% Evaluates a student’s grade based on GPA and level of education since a 3.9 in masters might be more impressive than a 4.0 in bachelors
% Checks to make sure value doesn’t exceed 4.0, then gives each combination of score and level of education its corresponding weight

gpaMetric(_, GPA, Score) :- 
    GPA > 4.0, 
    Score is 0.
gpaMetric(Degree, GPA, Score) :- 
    Degree = bach, 
    GPA >= 3.0, 
    Score is 1.
gpaMetric(Degree, GPA, Score) :- 
    Degree = masters, 
    GPA >= 2.8, 
    Score is 1.
gpaMetric(Degree, GPA, Score) :- 
    Degree = phd, 
    GPA >= 2.8, 
    Score is 1.
gpaMetric(Degree, GPA, Score) :- 
    Degree = bach, 
    GPA < 3.0, 
    Score is 0.5.
gpaMetric(Degree, GPA, Score) :- 
    Degree = masters, 
    GPA < 2.8, 
    Score is 0.5.
gpaMetric(Degree, GPA, Score) :- 
    Degree = phd, 
    GPA < 2.8, 
    Score is 0.5.

% Final function to get the actual number score generated from the GPA and Degree

acadMetric(Degree, GPA, FinalScore) :- 
    gpaMetric(Degree, GPA, Multiplier), 
    schoolMetric(Degree, Score), 
    FinalScore is Score*Multiplier.
acadMetric(Degree, _, FinalScore) :- 
    Degree \= phd,
    Degree \= masters,
    Degree \= bach,
    FinalScore is 0.

% Checks to see how much work experience a student has prior to applying for this internship
% We do keep in mind that this could be a first time applicant so prior work experience is not weight too highly on the larger scale

workExp(CompanyList, Score) :- 
    workExp_helper(CompanyList, 0, Score1), 
    Score1 < 20, 
    Score is Score1.
workExp(CompanyList, Score) :- 
    workExp_helper(CompanyList, 0, Score1), 
    Score1 >= 20, 
    Score is 20.
workExp_helper([], Score, Score).

% Company is classified as accredited_company or unknown_company to show how much weight it should have on the overall hiring process
workExp_helper([Company|List], PartialScore, Score) :- 
    Company = accredited_company, 
    P is PartialScore+10, 
    workExp_helper(List, P, Score).
workExp_helper([Company|List], PartialScore, Score) :- 
    Company = unknown_company, 
    P is PartialScore+7, 
    workExp_helper(List, P, Score).

% Checks to see how many technical languages given on the resume match the technical languages required by the company
% Checks to see each individual resume language with all company languages to see if they match

checkLang(Lang, [Lang|_]).
checkLang(Lang, [X|L]) :- Lang\= X, checkLang(Lang, L).

% Helps increment the value of count if a resume language matches a company specified language

countNumLang(Lang, CompanyLang, Count) :- countNumLang_helper(Lang, CompanyLang, 0, Count).  
countNumLang_helper([], _, P, P).
countNumLang_helper([H|T], CandidateLang, PartialCount, Count) :- 
    checkLang(H, CandidateLang), P is PartialCount+1, countNumLang_helper(T, CandidateLang, P, Count).
countNumLang_helper([H|T], CandidateLang, PartialCount, Count) :- 
    not checkLang(H, CandidateLang), countNumLang_helper(T, CandidateLang, PartialCount, Count).  

% Goes through all tech. languages given on the resume and is the function that will be used in the final, determining the interview process

langScore(List, Score) :- 
    countNumLang(List, [java, cpp, python], Num), 
    Num = 0,  Score is 0.

langScore(List, Score) :- 
    countNumLang(List, [java, cpp, python], Num), 
    Num \= 0, Score is Num * 5 + 20.

% Given any number of projects not exceeding 3, function finds score based on all previously evaluated projects (Maximum of 3)

projectRating([], 0). 
projectRating([H|T], ProjScore) :-  
    projectRating(T, NewScore), 
    ProjScore is NewScore + H.

% Compiles all the predicates to calculate the score or 'strength' of the given applicant

finalScore(Degree, GPA, CompanyList, LanguageList, ProjectList, RawScore) :-
    acadMetric(Degree, GPA, AcadScore), 
    workExp(CompanyList, CompScore),
    langScore(LanguageList, LangScore),
    projectRating(ProjectList, ProjScore),
    RawScore is AcadScore + CompScore + LangScore + ProjScore.

% Actual query that inputs all the resume values and checks to see if the applicant’s resume is good enough to cross the threshold that the company specifies and warrant an interview

getsInterview(Threshold, Degree, GPA, CompanyList, LanguageList, ProjectList) :-
    finalScore(Degree, GPA, CompanyList, LanguageList, ProjectList, RawScore), 
    RawScore >= Threshold,
    write('This person gets an interview').
getsInterview(Threshold, Degree, GPA, CompanyList, LanguageList, ProjectList) :-
    finalScore(Degree, GPA, CompanyList, LanguageList, ProjectList, RawScore), 
    RawScore < Threshold,
    write('This person does not get an interview').

% Actual testing queries
?- getsInterview(97, masters, 4.0, [accredited_company,accredited_company,accredited_company], [java,cpp,python], [10,10,10]).
% ?- getsInterview(70, bach, 3.5, [accredited_company, unknown_company, accredited_company], [java, cpp], [2,3,4]).
% ?- getsInterview(80, phd, 1.0, [], [cpp], [10,9,3]).
% ?- getsInterview(75, masters, 3.6, [accredited_company, accredited_company], [python, cpp, javascript], [2]).

% Way to call query: getsInterview(CompanyThreshold, DegreeCompleted, GPA, ListOfPriorJobs, ListOfTechnicalLanguages, ListOfProjects).
% CompanyThreshold is a number from 0 - 100 which is the minimum number an candidate's application must score to recieve an interview
% DegreeCompleted can be either bach, masters, or phd
% GPA is a GPA on a 4 point scale (int 0 <= x <= 4)
% ListOfPriorJobs is a list which takes the keywords accredited_company and small_company (see above)
% ListOfTechnicalLanguages is a list that lists all the technical languages a resume lists
% ListOfProjects is a list which takes in 3 number of 3 projects rated 0-10.
% ListOfPriorJobs should have 2 jobs ideally and ListOfProjects should have 3 Projects max.
% The output will be a sentence saying whether the student who submitted the resume should get an interview based on the threshold entered.



