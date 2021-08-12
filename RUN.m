% Hamid Basaeri

tic
Pop = 20:10:30;
Gen = 100:50:200;
EC = 1:2;
Tol = [1e-6, 1e-8, 1e-10];
q = 0;

for i = 1: length(Pop)
    for j = 1: length(Gen)
        for k = 1: length(EC)
            for t = 1: length(Tol)
                q = q + 1;
                qq = length(Pop)*length(Gen)*length(EC)*length(Tol);
                [X,FVAL,REASON,OUTPUT,POPULATION,SCORES]=PI_GA_ID(Pop(i),Gen(j), EC(k), Tol(t));
                disp(['iteration ', num2str(q), ' from ', num2str(qq), ' FVAL= ', num2str(FVAL)]);
                Result(q, [1:16]) = [FVAL, Pop(i), Gen(j), EC(k), Tol(t), X];
                clear X FVAL REASON OUTPUT POPULATION SCORES
            end
        end
    end
end
toc