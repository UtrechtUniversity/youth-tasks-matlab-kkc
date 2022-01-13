
% these parameters define the experiment
QDelays = [2 30 180 365];
MaxTrials = 160;
step = 0.5;
fixAmount = 10;

textVraag = 'Wat wil je liever?';
textVariableInt = '%i euro nu';
textFixedInt = '%i euro over\n\n%i dagen';
textVariableFrac = '%0.2f euro nu';
textFixedFrac = '%0.2f euro over\n\n%i dagen';
textUitleg = 'Uitleg van het spel\n\n\nJe krijgt zometeen telkens twee keuzes.\n\nDenk goed na over welke van de twee je\n\nliever zou hebben, en klik op jouw keuze.\n\n\nDruk op spatie om te beginnen.';
textKlaar = 'Je bent klaar met deze taak.\n\n\nBedankt voor het meedoen.';

%--- init variables -------------------------------------------------------

QConverged = zeros(1, length(QDelays));   % did the boundaries already converge for each delay
QResults = -1 * ones(1, length(QDelays)); % final converged value
DelayInds = 1 : length(QDelays);          % indices of the delays still in the test

qLLR = 10;                                % Larger Later Reward
qOUL = qLLR * ones(1, length(QDelays));   % Outer Upper Limit
qIUL = qLLR * ones(1, length(QDelays));   % Inner Upper Limit
qILL = zeros(1, length(QDelays));         % Inner Lower Limit
qOLL = zeros(1, length(QDelays));         % Outer Lower Limit
