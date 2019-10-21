%% Question1
A=[1,1,3;
   1,3,1;
   0,1,3]
ASquared=A^2
AInverse=inv(A)
AEVals=eigs(A)
AEValsProduct=prod(AEVals)
ADet=det(A)
Error_detAndProduct=AEValsProduct-ADet
    %Machine precision is ~2.2204e-16 so Error=O(3e-15) is acceptable

%% Question 2
AExp_Matlab=expm(A)

Tol_MatlabAndLoop=1e-12;
seriesLengthMax=1000;
seriesLengthVals=linspace(1,seriesLengthMax,seriesLengthMax);
ErrorVals=[];
for seriesLength=seriesLengthVals
    iVals=linspace(1,seriesLength,seriesLength);
    sumCurrent=eye(3);
    for i=iVals
        i;
        seriesTerm_i=A^i/factorial(i);
        sumCurrent=sumCurrent+seriesTerm_i;
    end
   AExp_Loop=sumCurrent;
   Error_MatlabAndLoop=norm(AExp_Matlab-AExp_Loop,2);
   ErrorVals(1,seriesLength)=Error_MatlabAndLoop;
   if Error_MatlabAndLoop<Tol_MatlabAndLoop
       fprintf('Number of series terms required for error less than %d: %d',Tol_MatlabAndLoop,N)
       break
   end
end
loglog(linspace(1,length(ErrorVals),length(ErrorVals)),ErrorVals)
xlabel('Number of terms in Taylor series')
ylabel('Difference between 2-Norm of expm sol and Taylor series sol')
    % It is not possible to achieve error less than O(1e-13) in 1000 its

%% Question 3
N=4;

D= @(N) sparse(toeplitz([2, -1, zeros(1,N-2)]));
I= @(N) speye(N); %sparse identity
A= @(N) kron(I(N),kron(I(N),D(N))) + kron(I(N),kron(D(N),I(N))) + kron(D(N),kron(I(N),I(N)));
b= @(N) ones(N^3,1);

AFull=full(A(N))
size(AFull) % size is (N^3,N^3)
spy(AFull);

NVals=linspace(10,70,7);
compTimeVals=zeros(1,length(NVals));
iSpan=linspace(1,length(NVals),length(NVals));
for i=iSpan
    N=NVals(i);
    tic;
    x=A(N)\b(N);
    compTime=toc;
    compTimeVals(1,i)=compTime;
end
NVals
compTimeVals
loglog(NVals,compTimeVals)
hold on
loglog(NVals,NVals.^(2))
hold off
xlabel('N','Interpreter','latex')
legend('Solution time','$N^2$','Interpreter','latex')
% scales like N^2 instead of N^3 so we save a power in order 

    


