X = xlsread('diabetes.csv');
Y = X(:,1);
X(:,1)=[];

X = zscore(X);
myKMeans(X, Y, 2);
myKMeans(X, Y, 3);
myKMeans(X, Y, 4);

function myKMeans(X, Y, k)
max_iter=100;
rng(0);
sz = size(X);
num_cols = sz(2);
num_rows = sz(1);
ref_vecs = zeros(k,'double');
ref_vecs = [];
done = 0;
iter = 1;

if num_cols>=3
    % Reduce data to 3D if more than 3 columns
    if num_cols == 3
        data_3D = X;
    elseif num_cols > 3
        [U,S,V] = svd(cov(X)); 
        eigenvectors = [V(:,1) V(:,2) V(:,3)];
        data_3D = X * eigenvectors;
    end
    % Init k vectors a1,...ak as ref vectors
    for j=1:k
        new_ref_vec = data_3D(randi(num_rows),:);
        ref_vecs = [ref_vecs;new_ref_vec];
    end
    % DEBUG purity through each iteration
    purity_array = zeros(num_rows,'double');
    purity_array = [];
    % Init figures
    figure(4)
    % Start main() loop
    while done <1 && iter < max_iter 
        % Calculate distance each element to the ref vectors
        D = zeros(num_rows,'double');
        D = [];
        for v=1:k
            D = [D sqrt(sum((data_3D - ref_vecs(v,:)).^2,2))];
        end
        C = zeros(num_rows,'double');
        % Store ref vecs to prev buffer and reset
        prev_ref_vecs = ref_vecs;
        ref_vecs = []; % Reset ref vecs
        purity = 0;     % Init purity for each iteration
        % Begin sort out the data by distance to ref vectors
        for v=1:k
            C=[];
            count_1 = 0;
            count_neg_1 = 0;
            for i=1:num_rows
                if D(i,v) == min(D(i,:))
                    C = [C;data_3D(i,:)];
                    if Y(i) == -1
                        count_neg_1 = count_neg_1 + 1;
                    elseif Y(i) == 1
                        count_1 = count_1 + 1;
                    end
                end
            end
            % Accumulate purity from each cluster
            local_purity = max(count_1,count_neg_1);
            purity = purity + local_purity;
            % Update ref vectors
            new_ref_vec = mean(C);
            ref_vecs = [ref_vecs;new_ref_vec];
            % Plot figure if done
            if v==1, color = 'r';
            elseif v == 2, color = 'b';
            elseif v == 3, color = 'y';
            elseif v == 4, color = 'g';
            elseif v == 5, color = 'm';
            elseif v == 6, color = 'c';
            else, color = 'k';
            end
            plot3(C(:,1),C(:,2),C(:,3),'x','Color',color);
            hold on
            plot3(ref_vecs(v,1),ref_vecs(v,2),ref_vecs(v,3),'o','MarkerFaceColor',color);       
            view(3)
        end
        % Calculate purity of each iteration
        purity = purity/num_rows;
        purity_array = [purity_array;purity];
        % Check if clusters centers converged. Sum of change < e=2^-23.
        d_ref = sum(sqrt(sum((ref_vecs - prev_ref_vecs).^2,2)));
        if d_ref < 2^(-23)
            done = 1; % signal draw flag and put it to done
        end
        xlabel('D1');
        ylabel('D2');
        zlabel('D3');
        title(['Iteration ' num2str(iter) ' purity = ' num2str(purity)]);
        F(iter) = getframe(gcf);
        drawnow
        hold off
        iter = iter + 1;
    end
    % create the video writer with 1 fps
    writerObj = VideoWriter(['K_' num2str(k) '.avi']);
    writerObj.FrameRate = 1;
    open(writerObj);
    % write the frames to the video
    for i=1:length(F)
        % convert the image to a frame
        frame = F(i) ;    
        writeVideo(writerObj, frame);
    end
    close(writerObj);
elseif num_cols == 2
    data_2D = X;
    % Init k vectors a1,...ak as ref vectors
    for j=1:k
        new_ref_vec = data_2D(randi(num_rows),:);
        ref_vecs = [ref_vecs;new_ref_vec];
    end
    % DEBUG purity through each iteration
    purity_array = zeros(num_rows,'double');
    purity_array = [];
    % Init figures
    figure(4)
    % Main() Loop
    while done <1 && iter < max_iter
        % Calculate distance each element to the ref vectors
        D = zeros(num_rows,'double');
        D = [];
        for v=1:k
            D = [D sqrt(sum((data_2D - ref_vecs(v,:)).^2,2))];
        end
        C = zeros(num_rows,'double');
        % Store ref vecs to prev buffer and reset
        prev_ref_vecs = ref_vecs;
        ref_vecs = []; % Reset ref vecs
        purity = 0;     % Init purity for each iteration
        % Begin sort out the data by distance to ref vectors
        for v=1:k
            C=[];
            count_1 = 0;
            count_neg_1 = 0;
            for i=1:num_rows
                if D(i,v) == min(D(i,:))
                    C = [C;data_2D(i,:)];
                    if Y(i) == -1
                        count_neg_1 = count_neg_1 + 1;
                    elseif Y(i) == 1
                        count_1 = count_1 + 1;
                    end        
                end
            end
            % Accumulate purity from each cluster
            local_purity = max(count_1,count_neg_1);
            purity = purity + local_purity;
            % Update ref vectors
            new_ref_vec = mean(C);
            ref_vecs = [ref_vecs;new_ref_vec];
            % Plot figure if done
            if v==1, color = 'r';
            elseif v == 2, color = 'b';
            elseif v == 3, color = 'y';
            elseif v == 4, color = 'g';
            elseif v == 5, color = 'm';
            elseif v == 6, color = 'c';
            else, color = 'k';
            end
            plot(C(:,1),C(:,2),'x','Color',color);
            hold on
            plot(ref_vecs(v,1),ref_vecs(v,2),'o','MarkerFaceColor',color);       
        end
        % Calculate purity of each iteration
        purity = purity/num_rows;
        purity_array = [purity_array;purity];
        % Check if clusters centers converged. Sum of change < e=2^-23.
        d_ref = sum(sqrt(sum((ref_vecs - prev_ref_vecs).^2,2)));
        if d_ref < 2^(-23)
            done = 1; % signal draw flag and put it to done
        end
        xlabel('D1');
        ylabel('D2');
        title(['Iteration ' num2str(iter) ' purity = ' num2str(purity)]);
        F(iter) = getframe(gcf);
        drawnow
        hold off
        iter = iter + 1;
    end
    % create the video writer with 1 fps
    writerObj = VideoWriter(['K_' num2str(k) '.avi']);
    writerObj.FrameRate = 1;
    open(writerObj);
    % write the frames to the video
    for i=1:length(F)
        % convert the image to a frame
        frame = F(i) ;    
        writeVideo(writerObj, frame);
    end
    close(writerObj);
end
end