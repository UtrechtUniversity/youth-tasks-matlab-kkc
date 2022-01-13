function [frames] = AnimToFrames(anim, numFrames)

frames = zeros(1, numFrames);

for curStep = 1 : size(anim, 1)-1
    
    stepStartFrame      = floor((anim(curStep,1)*(numFrames-1))+1);
    stepStartValue      = anim(curStep,2);
    
    stepEndFrame        = floor(anim(curStep+1,1)*(numFrames-1))+1;
    stepEndValue        = anim(curStep+1,2);
    
    curStepFrames       = stepEndFrame - stepStartFrame;
    curStepFrameChange  = (stepEndValue - stepStartValue) / curStepFrames;
    
    if curStepFrameChange==0
        frames(stepStartFrame:stepEndFrame) = repmat(stepStartValue, 1, curStepFrames+1);
    else
        frames(stepStartFrame:stepEndFrame) = [stepStartValue : curStepFrameChange : stepEndValue];
    end
end

