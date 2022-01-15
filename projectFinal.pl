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

acadMetric(Degree, GPA, FinalScore) :-  %GPA AND SCHOOL CALL
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

workExp(CompanyList, Score) :- %WORK EXPERIENCE CALL
    workExp_helper(CompanyList, 0, Score1), 
    Score1 < 20, 
    Score is Score1.
workExp(CompanyList, Score) :- 
    workExp_helper(CompanyList, 0, Score1), 
    Score1 >= 20, 
    Score is 20.
workExp_helper([], Score, Score).

% Company is classified as big or small to show how much weight it should have on the overall hiring process
workExp_helper([Company|List], PartialScore, Score) :- 
    Company = big, 
    P is PartialScore+10, 
    workExp_helper(List, P, Score).
workExp_helper([Company|List], PartialScore, Score) :- 
    Company = small, 
    P is PartialScore+7, 
    workExp_helper(List, P, Score).

% Checks to see how many languages given on the resume match the languages given by the company
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

% Goes through all languages given on the resume and is the function that will be used in the final, determining the interview process

langScore(List, Score) :- %GET LANGUAGE SCORE CALL
    countNumLang(List, [java, cpp, python], Num), 
    Num = 0,  Score is 0.

langScore(List, Score) :- %GET LANGUAGE SCORE CALL :)
    countNumLang(List, [java, cpp, python], Num), 
    Num \= 0, Score is Num * 5 + 20.

% Given any number of projects not exceeding 3, function finds score based on all previously evaluated projects (Maximum of 3)

projectRating([], 0). 
projectRating([H|T], ProjScore) :-  %GET PROJECT SCORE CALL :)
    projectRating(T, NewScore), 
    ProjScore is NewScore + H.

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

% Actual testing query
?- getsInterview(70, masters, 4.0, [big,big,big], [java,cpp,python], [10,10,10]).
