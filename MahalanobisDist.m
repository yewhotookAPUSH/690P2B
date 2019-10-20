function d = MahalanobisDist( X, S, M )

% Get Number of vectors N.
[m,N] = size( X );

% compute inverse of covariance (psuedo inverse is more tolerant)
SI = pinv(S);

d(N) = 0; % Preallocate output vector.

for k = 1:N
    % Compute distance from distribution to each vector.
    d(k) = sqrt((X(:,k)-M)'*SI*(X(:,k)-M));
end
