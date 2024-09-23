import numpy as np
def embeded(data,Pload,Tp,Tn,image_in):
    
    image_out = image_in
    mod_values = np.vstack(data[0:34, 5] % 2)

    Pload = np.concatenate((mod_values.flatten(), Pload.flatten()))
    Pload = Pload.reshape(1, -1)
  
    data_dum = data[34:, :]

    status = np.zeros((data_dum.shape[0], 0)) 

    status = np.zeros_like(data_dum[:, 0], dtype=int)
    con1 = (data_dum[:, 2] > Tp) & (data_dum[:, 4] + data_dum[:, 2] + Tp + 1 <= 255) & (data_dum[:, 4] + data_dum[:, 2] + 2*Tp + 2 <= 255)
    status[con1] = 1
    con2 = (data_dum[:, 2] > Tp) & (data_dum[:, 4] + data_dum[:, 2] + Tp + 1 <= 255) & (data_dum[:, 4] + data_dum[:, 2] + 2*Tp + 2 > 255)
    status[con2] = 2
    con3 = (data_dum[:, 2] > Tp) & (data_dum[:, 4] + data_dum[:, 2] + Tp + 1 > 255)
    status[con3] = 3
    
    con4 = (data_dum[:,2]>=0) & (data_dum[:,2]<=Tp) & ((data_dum[:,4]+2*data_dum[:,2]+1)<=255) & ((2*data_dum[:,2]+1)<=Tp) & ((data_dum[:,4]+2*(2*data_dum[:,2]+1)+1)<=255)
    status[con4] = 4   
    con5 = (data_dum[:,2]>=0) & (data_dum[:,2]<=Tp) & ((data_dum[:,4]+2*data_dum[:,2]+1)<=255) & ((2*data_dum[:,2]+1)<=Tp)&((data_dum[:,4]+2*(2*data_dum[:,2]+1)+1)>255)
    status[con5] = 5   
    con6 = (data_dum[:,2]>=0) & (data_dum[:,2]<=Tp) & ((data_dum[:,4]+2*data_dum[:,2]+1)<=255) & ((2*data_dum[:,2]+1)>Tp)&((data_dum[:,4]+(2*data_dum[:,2]+1)+Tp+1)<=255)
    status[con6] = 6
    con7 = (data_dum[:,2]>=0) & (data_dum[:,2]<=Tp) & ((data_dum[:,4]+2*data_dum[:,2]+1)<=255) & ((2*data_dum[:,2]+1)>Tp)&((data_dum[:,4]+(2*data_dum[:,2]+1)+Tp+1)>255)
    status[con7] = 7   
    con8 = (data_dum[:,2]>=0) & (data_dum[:,2]<=Tp) & ((data_dum[:,4]+2*data_dum[:,2]+1)>255) 
    status[con8] = 8 
    
    con9 = (data_dum[:,2]<0) & (data_dum[:,2]>=Tn) & ((data_dum[:,4]+2*data_dum[:,2])>=0) & (2*data_dum[:,2]>=Tn) & ((data_dum[:,4]+2*2*data_dum[:,2])>=0)
    status[con9]  = 9
    con10 = (data_dum[:,2]<0) & (data_dum[:,2]>=Tn) & ((data_dum[:,4]+2*data_dum[:,2])>=0) & (2*data_dum[:,2]>=Tn) & ((data_dum[:,4]+2*2*data_dum[:,2])<0)
    status[con10]  = 10
    con11 = (data_dum[:,2]<0) & (data_dum[:,2]>=Tn) & ((data_dum[:,4]+2*data_dum[:,2])>=0) & (2*data_dum[:,2]<Tn) & ((data_dum[:,4]+2*data_dum[:,2]+Tn)>=0)
    status[con11]  = 11
    con12 = (data_dum[:,2]<0) & (data_dum[:,2]>=Tn) & ((data_dum[:,4]+2*data_dum[:,2])>=0) & (2*data_dum[:,2]<Tn) & ((data_dum[:,4]+2*data_dum[:,2]+Tn)<0)
    status[con12]  = 12
    con13 = (data_dum[:,2]<0) & (data_dum[:,2]>=Tn) & ((data_dum[:,4]+2*data_dum[:,2])<0) 
    status[con13] = 13   
    con14 = (data_dum[:,2]<Tn) & ((data_dum[:,4]+data_dum[:,2]+Tn)>=0) & ((data_dum[:,4]+data_dum[:,2]+2*Tn)>=0)
    status[con14]  = 14
    con15 = (data_dum[:,2]<Tn) & ((data_dum[:,4]+data_dum[:,2]+Tn)>=0) & ((data_dum[:,4]+data_dum[:,2]+2*Tn)<0)
    status[con15]  = 14   
    con16 = (data_dum[:,2]<Tn) & ((data_dum[:,4]+data_dum[:,2]+Tn)<0) 
    status[con16] = 16 
    d = data_dum[:, 2]
    uh = data_dum[:, 4]
    U = data_dum[:, 6]
    mask1 = (status == 1) | (status == 2)
    U[mask1] = uh[mask1] + d[mask1] + Tp + 1
    mask2 = (status == 4) | (status == 6)
    U[mask2] = uh[mask2] + 2*d[mask2]
    mask3 = (status == 5) | (status == 7)
    U[mask3] = uh[mask3] + 2*d[mask3] + 1
    mask4 = (status == 9) | (status == 11)
    U[mask4] = uh[mask4] + 2*d[mask4]
    mask5 = (status == 10) | (status == 12)
    U[mask5] = uh[mask5] + 2*d[mask5]
    mask6 = (status == 14) | (status == 15)
    U[mask6] = uh[mask6] + d[mask6] + Tn
    mask7 = (status == 3) | (status == 8)
    U[mask7] = uh[mask7] + d[mask7]
    mask8 = (status == 13) | (status == 16)
    U[mask8] = uh[mask8] + d[mask8]

    L_chk = ~(status == 1) | (status == 4) | (status == 6) | (status == 9) | (status == 11) | (status == 14)
    E_chk = (status == 4) | (status == 6) | (status == 9) | (status == 11)
    Last_bit = np.where(np.cumsum(L_chk) + len(Pload) == np.cumsum(E_chk))[0]
    if Last_bit.size > 0:
        L = np.zeros((len(status), 1), dtype=int)
        L[(status == 3) | (status == 8) | (status == 13) | (status == 16)] = 1
        L = L[L_chk & (np.arange(len(status)) <= Last_bit[0])]
        U[E_chk & (np.arange(len(status)) <= Last_bit[0])] += np.concatenate((Pload, L))
        U[Last_bit[0]+1:] = uh[Last_bit[0]+1:] + d[Last_bit[0]+1:]
        data[34:, 6] = U
    # Convert Tp, Tn, and length of payload to binary and pack into first 34 bits
        bin_data = np.packbits(np.concatenate((np.floor(data[:34, 6] / 2) * 2,
              np.unpackbits(np.array([Tp], dtype=np.uint8).tobytes()),
              np.unpackbits(np.array([abs(Tn)], dtype=np.uint8).tobytes()),
              np.unpackbits(np.array([len(Pload)], dtype=np.uint32).tobytes()))))
        data[:34, 6] = bin_data
        image_out[(data[:, 0] - 1) * image_out.shape[1] + data[:, 1]] = data[:, 6]
        plcheck = 1
    else:
        plcheck = 0

    return image_out, plcheck





# function [image_out,plcheck]=embeded_modification2(data,Pload,Tp,Tn,image_in)
#  image_out=image_in;
#  Pload=[mod(data(1:34,6),2)' Pload]';
 
#  data_dum=data(35:end,:);
#  status=zeros(size(data_dum,1),1);
#  status((data_dum(:,3)>Tp)&((data_dum(:,5)+data_dum(:,3)+Tp+1)<=255)&...
#         ((data_dum(:,5)+data_dum(:,3)+2*Tp+2)<=255))=1;
#  status((data_dum(:,3)>Tp)&((data_dum(:,5)+data_dum(:,3)+Tp+1)<=255)&...
#         ((data_dum(:,5)+data_dum(:,3)+2*Tp+2)>255))=2;
#  status((data_dum(:,3)>Tp)&((data_dum(:,5)+data_dum(:,3)+Tp+1)>255))=3;  
 
#  status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)<=255)&...
#         ((2*data_dum(:,3)+1)<=Tp)&((data_dum(:,5)+2*(2*data_dum(:,3)+1)+1)<=255))=4;   
#  status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)<=255)&...
#         ((2*data_dum(:,3)+1)<=Tp)&((data_dum(:,5)+2*(2*data_dum(:,3)+1)+1)>255))=5;   
#  status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)<=255)&...
#         ((2*data_dum(:,3)+1)>Tp)&((data_dum(:,5)+(2*data_dum(:,3)+1)+Tp+1)<=255))=6;   
#  status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)<=255)&...
#         ((2*data_dum(:,3)+1)>Tp)&((data_dum(:,5)+(2*data_dum(:,3)+1)+Tp+1)>255))=7;   
#  status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)>255))=8;   
 
#  status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))>=0)&...
#         (2*data_dum(:,3)>=Tn)&((data_dum(:,5)+2*2*data_dum(:,3))>=0))=9;
#  status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))>=0)&...
#         (2*data_dum(:,3)>=Tn)&((data_dum(:,5)+2*2*data_dum(:,3))<0))=10;   
#  status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))>=0)&...
#         (2*data_dum(:,3)<Tn)&((data_dum(:,5)+2*data_dum(:,3)+Tn)>=0))=11;   
#  status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))>=0)&...
#         (2*data_dum(:,3)<Tn)&((data_dum(:,5)+2*data_dum(:,3)+Tn)<0))=12;   
#  status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))<0))=13;   
    
#  status((data_dum(:,3)<Tn)&((data_dum(:,5)+data_dum(:,3)+Tn)>=0)&...
#         ((data_dum(:,5)+data_dum(:,3)+2*Tn)>=0))=14;
#  status((data_dum(:,3)<Tn)&((data_dum(:,5)+data_dum(:,3)+Tn)>=0)&...
#         ((data_dum(:,5)+data_dum(:,3)+2*Tn)<0))=15;   
#  status((data_dum(:,3)<Tn)&((data_dum(:,5)+data_dum(:,3)+Tn)<0))=16;    
    
#  d=data_dum(:,3);
#  uh=data_dum(:,5);
#  U=data_dum(:,7);
#  U(status==1|status==2)=uh(status==1|status==2)+d(status==1|status==2)+Tp+1;
#  U(status==4|status==6)=uh(status==4|status==6)+2*d(status==4|status==6);
#  U(status==5|status==7)=uh(status==5|status==7)+2*d(status==5|status==7)+1;
#  U(status==9|status==11)=uh(status==9|status==11)+2*d(status==9|status==11);
#  U(status==10|status==12)=uh(status==10|status==12)+2*d(status==10|status==12);
#  U(status==14|status==15)=uh(status==14|status==15)+d(status==14|status==15)+Tn;
#  U(status==3|status==8)=uh(status==3|status==8)+d(status==3|status==8);
#  U(status==13|status==16)=uh(status==13|status==16)+d(status==13|status==16);
 
#  L_chk=~(status==1|status==4|status==6|status==9|status==11|status==14);
#  E_chk=(status==4|status==6|status==9|status==11);
 
#  Last_bit=find(cumsum(L_chk)+length(Pload)==cumsum(E_chk));
 
#  if ~isempty(Last_bit)
#      L=zeros(length(status),1);
#      L(status==3|status==8|status==13|status==16)=1;
#      L=L(L_chk & ((1:length(status))<=Last_bit(1))');
     
#      % we are putting the payload and map into E set
#      U(E_chk & ((1:length(status))<=Last_bit(1))')=U(E_chk & (1:length(status))'<=Last_bit(1))+[Pload; L];
#      U((Last_bit(1)+1):end)=uh((Last_bit(1)+1):end)+d((Last_bit(1)+1):end);
#      data(35:end,7)=U;
         
#      % we are putting the Tp,Tn and a length of payload into the first 34 bits. 
#      data(1:34,7)=floor(data(1:34,7)/2)*2+[dec2binvec(Tp,7) dec2binvec(abs(Tn),7) dec2binvec(length(Pload),20)]';
#      image_out((data(:,1)-1)*size(image_out,2)+data(:,2))=data(:,7);
#      plcheck=1; 
#  else
#      plcheck=0; 
#  end
# end
