import numpy as np

def dotset(av_cross_image):
    # Find size of image.
    N, M = av_cross_image.shape
    # Cross mark.
    A1 = av_cross_image[0:N-3:2, 2:M-1:2]
    A2 = av_cross_image[1:N-2:2, 1:M-2:2]
    B1 = av_cross_image[2:N-1:2, 2:M-1:2]
    B2 = av_cross_image[3:N:2, 1:M-2:2]
    C1 = av_cross_image[1:N-2:2, 1:M-2:2]
    C2 = av_cross_image[2:N-1:2, 0:M-3:2]
    D1 = av_cross_image[1:N-2:2, 3:M:2]
    D2 = av_cross_image[2:N-1:2, 2:M-1:2]
    # Reshape to column.
    A1 = A1.flatten(order='F').reshape(-1, 1)
    A2 = A2.flatten(order='F').reshape(-1, 1)
    B1 = B1.flatten(order='F').reshape(-1, 1)
    B2 = B2.flatten(order='F').reshape(-1, 1)
    C1 = C1.flatten(order='F').reshape(-1, 1)
    C2 = C2.flatten(order='F').reshape(-1, 1)
    D1 = D1.flatten(order='F').reshape(-1, 1)
    D2 = D2.flatten(order='F').reshape(-1, 1)
    # Compile coulumn.
    A = np.vstack((A1, A2))
    B = np.vstack((B1, B2))
    C = np.vstack((C1, C2))
    D = np.vstack((D1, D2))
    # Find maens of stack.
    datas = np.array([A, B, C, D])

    uh = np.round(np.mean(datas, axis=0))
    # Find varience.
    mu = np.var(datas, axis=0, ddof=0)
    # Create value of cross mark.
    u1 = av_cross_image[1:N-2:2, 2:M-1:2]  
    u2 = av_cross_image[2:N-1:2, 1:M-2:2]  
    u1 = u1.flatten(order='F').reshape(-1, 1)
    u2 = u2.flatten(order='F').reshape(-1, 1)

    u = np.vstack((u1, u2))
    print(u)
    d = u - uh

    [c1, r1] = np.meshgrid(np.arange(2, N-1, 2), np.arange(2, M-1, 2))
    [c2, r2] = np.meshgrid(np.arange(3, N, 2), np.arange(3, M, 2))
    
    c1 = c1.flatten(order='F').reshape(-1, 1)
    c2 = c2.flatten(order='F').reshape(-1, 1)
    r1 = r1.flatten(order='F').reshape(-1, 1)
    r2 = r2.flatten(order='F').reshape(-1, 1)
    # print(c1)
    # print(c2)
    c = np.vstack((c1, c2))
    r = np.vstack((r1, r2))
    

    # Compile u1 และ u2 เข้าด้วยกัน
    u = np.vstack((u1, u2))
    # print("This is c")
    # print(c)
    # print("This is r")
    # print(r)
    # print("This is d")
    # print(d)
    # print("This is varieance")
    # print(uh)
    # print("This is u")
    # print(u)
    # Complie c, r, d, mu, uh, u to a matrix.
    data = np.hstack((c, r, d, mu, uh, u, u))
    print("Data not sort : ", data)
    # print(data)
  
    sort = np.argsort(data[:, 3])  
    data = data[sort, :]  
    # print(data[:,[3]])
    # print(data[:, [3]])
    # c, r, u,
    return data
