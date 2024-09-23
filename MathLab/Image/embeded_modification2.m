function [image_out,plcheck]=embeded_modification2(data,Pload,Tp,Tn,image_in)
 image_out=image_in;
 Pload=[mod(data(1:34,6),2)' Pload]';
 
 data_dum=data(35:end,:);
 status=zeros(size(data_dum,1),1);
 status((data_dum(:,3)>Tp)&((data_dum(:,5)+data_dum(:,3)+Tp+1)<=255)&...
        ((data_dum(:,5)+data_dum(:,3)+2*Tp+2)<=255))=1;
 status((data_dum(:,3)>Tp)&((data_dum(:,5)+data_dum(:,3)+Tp+1)<=255)&...
        ((data_dum(:,5)+data_dum(:,3)+2*Tp+2)>255))=2;
 status((data_dum(:,3)>Tp)&((data_dum(:,5)+data_dum(:,3)+Tp+1)>255))=3;  
 
 status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)<=255)&...
        ((2*data_dum(:,3)+1)<=Tp)&((data_dum(:,5)+2*(2*data_dum(:,3)+1)+1)<=255))=4;   
 status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)<=255)&...
        ((2*data_dum(:,3)+1)<=Tp)&((data_dum(:,5)+2*(2*data_dum(:,3)+1)+1)>255))=5;   
 status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)<=255)&...
        ((2*data_dum(:,3)+1)>Tp)&((data_dum(:,5)+(2*data_dum(:,3)+1)+Tp+1)<=255))=6;   
 status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)<=255)&...
        ((2*data_dum(:,3)+1)>Tp)&((data_dum(:,5)+(2*data_dum(:,3)+1)+Tp+1)>255))=7;   
 status((data_dum(:,3)>=0)&(data_dum(:,3)<=Tp)&((data_dum(:,5)+2*data_dum(:,3)+1)>255))=8;   
 
 status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))>=0)&...
        (2*data_dum(:,3)>=Tn)&((data_dum(:,5)+2*2*data_dum(:,3))>=0))=9;
 status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))>=0)&...
        (2*data_dum(:,3)>=Tn)&((data_dum(:,5)+2*2*data_dum(:,3))<0))=10;   
 status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))>=0)&...
        (2*data_dum(:,3)<Tn)&((data_dum(:,5)+2*data_dum(:,3)+Tn)>=0))=11;   
 status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))>=0)&...
        (2*data_dum(:,3)<Tn)&((data_dum(:,5)+2*data_dum(:,3)+Tn)<0))=12;   
 status((data_dum(:,3)<0)&(data_dum(:,3)>=Tn)&((data_dum(:,5)+2*data_dum(:,3))<0))=13;   
    
 status((data_dum(:,3)<Tn)&((data_dum(:,5)+data_dum(:,3)+Tn)>=0)&...
        ((data_dum(:,5)+data_dum(:,3)+2*Tn)>=0))=14;
 status((data_dum(:,3)<Tn)&((data_dum(:,5)+data_dum(:,3)+Tn)>=0)&...
        ((data_dum(:,5)+data_dum(:,3)+2*Tn)<0))=15;   
 status((data_dum(:,3)<Tn)&((data_dum(:,5)+data_dum(:,3)+Tn)<0))=16;    
    
 d=data_dum(:,3);
 uh=data_dum(:,5);
 U=data_dum(:,7);
 U(status==1|status==2)=uh(status==1|status==2)+d(status==1|status==2)+Tp+1;
 U(status==4|status==6)=uh(status==4|status==6)+2*d(status==4|status==6);
 U(status==5|status==7)=uh(status==5|status==7)+2*d(status==5|status==7)+1;
 U(status==9|status==11)=uh(status==9|status==11)+2*d(status==9|status==11);
 U(status==10|status==12)=uh(status==10|status==12)+2*d(status==10|status==12);
 U(status==14|status==15)=uh(status==14|status==15)+d(status==14|status==15)+Tn;
 U(status==3|status==8)=uh(status==3|status==8)+d(status==3|status==8);
 U(status==13|status==16)=uh(status==13|status==16)+d(status==13|status==16);
 
 L_chk=~(status==1|status==4|status==6|status==9|status==11|status==14);
 E_chk=(status==4|status==6|status==9|status==11);
 
 Last_bit=find(cumsum(L_chk)+length(Pload)==cumsum(E_chk));
 
 if ~isempty(Last_bit)
     L=zeros(length(status),1);
     L(status==3|status==8|status==13|status==16)=1;
     L=L(L_chk & ((1:length(status))<=Last_bit(1))');
     
     % we are putting the payload and map into E set
     U(E_chk & ((1:length(status))<=Last_bit(1))')=U(E_chk & (1:length(status))'<=Last_bit(1))+[Pload; L];
     U((Last_bit(1)+1):end)=uh((Last_bit(1)+1):end)+d((Last_bit(1)+1):end);
     data(35:end,7)=U;
         
     % we are putting the Tp,Tn and a length of payload into the first 34 bits. 
     data(1:34,7)=floor(data(1:34,7)/2)*2+[dec2binvec(Tp,7) dec2binvec(abs(Tn),7) dec2binvec(length(Pload),20)]';
     image_out((data(:,1)-1)*size(image_out,2)+data(:,2))=data(:,7);
     plcheck=1; 
 else
     plcheck=0; 
 end
end
