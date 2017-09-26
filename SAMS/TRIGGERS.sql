
  CREATE OR REPLACE TRIGGER "SCOTT"."ACTIVITY_MASTER_TRIGGER" before insert on "SCOTT"."ACTIVITY_MASTER"    for each row begin     if inserting then       if :NEW."ACT_ID" is null then          select ACTIVITY_MASTER_SEQUENCE.nextval into :NEW."ACT_ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."ACTIVITY_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."ADD_PRODUCT_MASTER" before insert on "SCOTT"."PRODUCT_MASTER"    for each row begin     if inserting then       if :NEW."ID" is null then          select PRODUCT_MASTER_SEQUENCE.nextval into :NEW."ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."ADD_PRODUCT_MASTER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."CLIENT_MASTER_TRIGGER" before insert on "SCOTT"."CLIENT_MASTER"    for each row begin     if inserting then       if :NEW."CL_ID" is null then          select CLIENT_MASTER_SEQUENCE.nextval into :NEW."CL_ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."CLIENT_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."COMPANY_MASTER_TRIGGER" before insert on "SCOTT"."COMPANY_MASTER"    for each row begin     if inserting then       if :NEW."C_ID" is null then          select COMPANY_MASTER_SEQUENCE.nextval into :NEW."C_ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."COMPANY_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."DEPT_MASTER_TRIGGER" before insert on "SCOTT"."DEPT_MASTER"    for each row begin     if inserting then       if :NEW."ID" is null then          select DEPT_MASTER_SEQUENCE.nextval into :NEW."ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."DEPT_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."DESIG_MASTER_TRIGGER" before insert on "SCOTT"."DESIG_MASTER"    for each row begin     if inserting then       if :NEW."ID" is null then          select DESIG_MASTER_SEQUENCE.nextval into :NEW."ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."DESIG_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."LEAD_MASTER_TRIGGER" before insert on "SCOTT"."LEAD_MASTER"    for each row begin     if inserting then       if :NEW."LEAD_ID" is null then          select LEAD_MASTER_SEQUENCE.nextval into :NEW."LEAD_ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."LEAD_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."PREV_SALES_MASTER_TRIGGER" before insert on "SCOTT"."PREV_SALES_MASTER"    for each row begin     if inserting then       if :NEW."ID" is null then          select PREV_SALES_MASTER_SEQUENCE.nextval into :NEW."ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."PREV_SALES_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."SALESMAN_MASTER_TRIGGER" before insert on "SCOTT"."SALESMAN_MASTER"    for each row begin     if inserting then       if :NEW."ID" is null then          select SALESMAN_MASTER_SEQUENCE.nextval into :NEW."ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."SALESMAN_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."SALESMANAGER_MASTER_TRIGGER" before insert on "SCOTT"."SALESMANAGER_MASTER"    for each row begin     if inserting then       if :NEW."ID" is null then          select SALESMANAGER_MASTER_SEQUENCE.nextval into :NEW."ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."SALESMANAGER_MASTER_TRIGGER" ENABLE;
 

  CREATE OR REPLACE TRIGGER "SCOTT"."STOCK_MASTER_TRIGGER" before insert on "SCOTT"."STOCK_MASTER"    for each row begin     if inserting then       if :NEW."ST_ID" is null then          select STOCK_MASTER_SEQUENCE.nextval into :NEW."ST_ID" from dual;       end if;    end if; end;
/
ALTER TRIGGER "SCOTT"."STOCK_MASTER_TRIGGER" ENABLE;
 
