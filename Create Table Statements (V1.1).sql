CREATE TABLE Client_Type (
    client_type_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    type_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(200)
);

CREATE TABLE Client (
    client_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    client_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    address NVARCHAR(200) NOT NULL,
    client_type_id BIGINT NOT NULL,
    FOREIGN KEY (client_type_id) REFERENCES Client_Type(client_type_id)
);

CREATE INDEX idx_client_client_type_id ON Client(client_type_id);
CREATE INDEX idx_client_client_name ON Client(client_name);

CREATE TABLE Branch (
    branch_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    branch_name NVARCHAR(100) NOT NULL,
    location NVARCHAR(200) NOT NULL
);

CREATE INDEX idx_branch_location ON Branch(location);

CREATE TABLE Position (
    position_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    position_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(200)
);

CREATE TABLE Employee (
    employee_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    branch_id BIGINT NOT NULL,
    position_id BIGINT NOT NULL,
    employee_name NVARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(15,2) NOT NULL CHECK(salary >= 0),
    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id),
    FOREIGN KEY (position_id) REFERENCES Position(position_id)
);

CREATE INDEX idx_employee_branch_id ON Employee(branch_id);
CREATE INDEX idx_employee_position_id ON Employee(position_id);
CREATE INDEX idx_employee_salary ON Employee(salary);

CREATE TABLE Account_Type (
    account_type_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    type_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(200)
);

CREATE TABLE Account (
    account_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    client_id BIGINT NOT NULL,
    account_type_id BIGINT NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0 CHECK(balance >= 0),
    opening_date DATE NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (account_type_id) REFERENCES Account_Type(account_type_id)
);

CREATE INDEX idx_account_client_id ON Account(client_id);
CREATE INDEX idx_account_account_type_id ON Account(account_type_id);
CREATE INDEX idx_account_balance ON Account(balance);

CREATE TABLE Transaction_Table_Type (
    transaction_table_type_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    type_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(200)
);

CREATE TABLE Transaction_Table (
    transaction_table_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    account_id BIGINT NOT NULL,
    transaction_table_type_id BIGINT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date DATE NOT NULL,
    FOREIGN KEY (account_id) REFERENCES Account(account_id),
    FOREIGN KEY (transaction_table_type_id) REFERENCES Transaction_Table_Type(transaction_table_type_id)
);

CREATE INDEX idx_transaction_account_id ON Transaction_Table(account_id);
CREATE INDEX idx_transaction_type_id ON Transaction_Table(transaction_table_type_id);
CREATE INDEX idx_transaction_date ON Transaction_Table(transaction_date);
CREATE INDEX idx_transaction_account_date ON Transaction_Table(account_id, transaction_date);

CREATE TABLE Financial_Product_Type (
    financial_product_type_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    type_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(200)
);

CREATE TABLE Risk_Profile (
    risk_profile_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    risk_level NVARCHAR(20) NOT NULL,
    return_rate DECIMAL(5,2) NOT NULL CHECK(return_rate >= 0),
    description NVARCHAR(200)
);

CREATE TABLE Financial_Product (
    financial_product_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    product_name NVARCHAR(100) NOT NULL,
    financial_product_type_id BIGINT NOT NULL,
    risk_profile_id BIGINT NOT NULL,
    FOREIGN KEY (financial_product_type_id) REFERENCES Financial_Product_Type(financial_product_type_id),
    FOREIGN KEY (risk_profile_id) REFERENCES Risk_Profile(risk_profile_id)
);

CREATE INDEX idx_product_type ON Financial_Product(financial_product_type_id);
CREATE INDEX idx_product_risk ON Financial_Product(risk_profile_id);


CREATE TABLE Investment (
    investment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    transaction_table_id BIGINT NOT NULL,
    financial_product_id BIGINT NOT NULL,
    invested_amount DECIMAL(15,2) NOT NULL,
    investment_date DATE NOT NULL,
    performance DECIMAL(5,2),
    FOREIGN KEY (transaction_table_id) REFERENCES Transaction_Table(transaction_table_id),
    FOREIGN KEY (financial_product_id) REFERENCES Financial_Product(financial_product_id)
);

CREATE INDEX idx_investment_transaction_id ON Investment(transaction_id);
CREATE INDEX idx_investment_product_id ON Investment(financial_product_id);
CREATE INDEX idx_investment_performance ON Investment(performance);

CREATE TABLE Loan (
    loan_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    client_id BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    branch_id BIGINT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

CREATE INDEX idx_loan_client_id ON Loan(client_id);
CREATE INDEX idx_loan_branch_id ON Loan(branch_id);
CREATE INDEX idx_loan_employee_id ON Loan(employee_id);

CREATE TABLE Payment (
    payment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    loan_id BIGINT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (loan_id) REFERENCES Loan(loan_id)
);

CREATE INDEX idx_payment_loan_id ON Payment(loan_id);
CREATE INDEX idx_payment_date ON Payment(payment_date);

CREATE TABLE Portfolio (
    portfolio_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    client_id BIGINT NOT NULL,
    total_invested DECIMAL(15,2),
    total_return DECIMAL(15,2),
    last_updated DATE,
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);

CREATE TABLE Portfolio_Investment (
    portfolio_investment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
    portfolio_id BIGINT NOT NULL,
    investment_id BIGINT NOT NULL,
    allocation_percentage DECIMAL(5,2),
    FOREIGN KEY (portfolio_id) REFERENCES Portfolio(portfolio_id),
    FOREIGN KEY (investment_id) REFERENCES Investment(investment_id)
);

CREATE INDEX idx_portfolio_client_id ON Portfolio(client_id);
CREATE INDEX idx_portfolio_investment_portfolio_id ON Portfolio_Investment(portfolio_id);
CREATE INDEX idx_portfolio_investment_investment_id ON Portfolio_Investment(investment_id);
