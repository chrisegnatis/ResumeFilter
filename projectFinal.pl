
schoolMetric(Degree, Score) :- 
    Degree = bach, 
    Score is 12.
schoolMetric(Degree, Score) :- 
    Degree = masters, 
    Score is 15.
schoolMetric(Degree, Score) :- 
    Degree = phd, 
    Score is 15.

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

acadMetric(Degree, GPA, FinalScore) :-  %GPA AND SCHOOL CALL
    gpaMetric(Degree, GPA, Multiplier), 
    schoolMetric(Degree, Score), 
    FinalScore is Score*Multiplier.
acadMetric(Degree, _, FinalScore) :- 
    Degree \= phd,
    Degree \= masters,
    Degree \= bach,
    FinalScore is 0.

workExp(CompanyList, Score) :- %WORK EXPERIENCE CALL
    workExp_helper(CompanyList, 0, Score1), 
    Score1 < 20, 
    Score is Score1.
workExp(CompanyList, Score) :- 
    workExp_helper(CompanyList, 0, Score1), 
    Score1 >= 20, 
    Score is 20.
workExp_helper([], Score, Score).
workExp_helper([Company|List], PartialScore, Score) :- 
    Company = big, 
    P is PartialScore+10, 
    workExp_helper(List, P, Score).
workExp_helper([Company|List], PartialScore, Score) :- 
    Company = small, 
    P is PartialScore+7, 
    workExp_helper(List, P, Score).

checkLang(Lang, [Lang|_]).
checkLang(Lang, [X|L]) :- Lang\= X, checkLang(Lang, L).

countNumLang(Lang, CompanyLang, Count) :- countNumLang_helper(Lang, CompanyLang, 0, Count).  
countNumLang_helper([], _, P, P).
countNumLang_helper([H|T], CandidateLang, PartialCount, Count) :- 
    checkLang(H, CandidateLang), P is PartialCount+1, countNumLang_helper(T, CandidateLang, P, Count).
countNumLang_helper([H|T], CandidateLang, PartialCount, Count) :- 
    not checkLang(H, CandidateLang), countNumLang_helper(T, CandidateLang, PartialCount, Count).  

langScore(List, Score) :- %GET LANGUAGE SCORE CALL
    countNumLang(List, [java, cpp, python], Num), 
    Num = 0,  Score is 0.

langScore(List, Score) :- %GET LANGUAGE SCORE CALL :)
    countNumLang(List, [java, cpp, python], Num), 
    Num \= 0, Score is Num * 5 + 20.

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

getsInterview(Threshold, Degree, GPA, CompanyList, LanguageList, ProjectList) :-
    finalScore(Degree, GPA, CompanyList, LanguageList, ProjectList, RawScore), 
    RawScore >= Threshold,
    write('This person gets an interview').
getsInterview(Threshold, Degree, GPA, CompanyList, LanguageList, ProjectList) :-
    finalScore(Degree, GPA, CompanyList, LanguageList, ProjectList, RawScore), 
    RawScore < Threshold,
    write('This person does not get an interview').

?- getsInterview(70, masters, 4.0, [big,big,big], [java,cpp,python], [10,10,10]).
