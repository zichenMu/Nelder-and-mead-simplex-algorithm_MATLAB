clear, clc

f = @(x) 0.6382*x(1)^2 + 0.3191*x(2)^2 - 0.2809*x(1)*x(2) - 67.906*x(1) - 14.290*x(2);
%Nelder and mead algorithm works 100 percent correctly. this works also for
%one variable and multivariable also.


%definitions
n=2;
x0=[0 0];
alpha=1;
beta=0.5;
gamma=2; 
delta=0.5;
lambda=1;
eps1=1;
eps2=4;
K=1;

keep = 0;

%%
for K=1:inf % will be returned for m times
    S=zeros(1,n+1);keep1=0;% For the 6th step

    %2-Generation of the initial simplex.

    D1=lambda*(sqrt(n+1)+n-1)/sqrt(2)*n;
    D2=lambda*(sqrt(n+1)-1)/sqrt(2)*n;
    x=zeros(n,n+1);
    x(:,1);
    x0;
    x(:,1)=x0;
    for k=2:n+1
        for i=1:n
            if i==k
                x(i,k)=x0(i)+D1;
            else
                x(i,k)=x0(i)+D2;
            end
        end
    end
    xbackup=x;
    % Simplex corners are defined.

    for KK=1:inf 

        %% 3- Findings
        F=zeros(1,n+1);
        for i=1:n+1
            F(i)=f(x(:,i));
        end
        Fmin=min(F);
        Fbackup=F;
        Fmax=max(F);
        if n>1
            [ignore, index] = max(F); 
            F(index) = -Inf;
            Fmax2 = max(F);
        end
        
        %%

        b=2;
        for j=1:n+1
            for k=b:n+1
                Diff=x(:,j)-x(:,k);
                u=0;
                for s=1:n
                    u=u+Diff(s)^2;
                end
                Length=sqrt(u);
                if Length<eps1 && abs(f(x(:,j))-f(x(:,k)))<eps2
                    for i=1:n+1
                        if f(x(:,i))==Fmin
                            xmin=x(:,i);
                            break
                        end
                    end
                    keep=1;
                    xmin
                    Fmin = f(xmin)
                    imin=i;
                    break 
                end
            end
            b=b+1;
            if b>n+1
                break
            end
            if keep==1
                break
            end
            
        end
        if keep==1
            break
        end

        %%
        for i=1:n+1
            if f(x(:,i))==Fmax
                xmax=x(:,i);imax=i;
                break
            end
        end
        xs=0;
        for i=1:n+1
            if i==imax
                xs=xs;
            else
                xs=xs+x(:,i);
            end
        end
        xs=xs/n;
        xnew=xmax+2*(xs-xmax);
        Fnew=f(xnew);
        if n==1
            if Fmin<=Fnew && Fnew<Fmax
                theta=beta;
            else if Fnew>=Fmax
                    theta=-beta;
                else if Fnew<=Fmin
                        theta=gamma;
                    end
                end
            end
        else if Fmin<Fnew && Fnew<Fmax2
            theta=alpha;
        else if Fmax2<=Fnew && Fnew<Fmax
                theta=beta;
            else if Fnew>=Fmax
                    theta=-beta;
                else if Fnew<=Fmin
                        theta=gamma;
                    end
                end
            end
            end
        end
        x(:,imax)=x(:,imax)+(1+theta)*(xs-x(:,imax));

        %%

        change=x-xbackup;
        for i=1:n+1
            if change(:,i)==zeros(n,1)
                S(i)=S(i)+1;
            end
        end
        m=round(1.65*n+.05*n^2);
        for i=1:n+1
            if S(i)==m
                keep1=1;
                break
            end
        end
        if keep1==1 || keep==1
            break
        end

    end

    if keep==1
        break
    end
    lambda=delta*lambda;
   
end

