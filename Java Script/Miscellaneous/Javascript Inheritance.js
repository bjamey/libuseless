// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Javascript Inheritance
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

// -----------------------
// Javascript Inheritance
// -----------------------


//--------------------------------------------
// IEmployee Class - Basic employee class
//--------------------------------------------
function IEmployee(name, department)
{
  this.IEmployee = this;

  this.name = name;
  this.department = department;

  this.work = function()
  {
    alert(this.name + ' is working for 8 hours in the ' + this.department + ' department.');
  }
}

//-----------------------------------------------
// IManager - Class inherits from IEmployee
//-----------------------------------------------
function IManager(name, department)
{
  this.IManager = this;

  // Call the base constructor.
  IEmployee.call(this, name, department);

  this.work = function()
  {
    alert(this.name + ' is telling peeps what to do for 6 hours in the ' + this.department + ' department.');
  }
}
IManager.prototype = new IEmployee;

//--------------------------------------------------
// ISalesPerson - Class inherits from IEmployee
//--------------------------------------------------
function ISalesPerson(name, department, quota)
{
  this.ISalesPerson = this;
  this.expectedQuota = quota;
  this.currentQuota = 0;

  IEmployee.call(this, name, department);

  this.sell = function(dollarAmount)
  {
    if (this.currentQuota < this.expectedQuota) this.currentQuota += dollarAmount;
    this.IEmployee.work();
    alert('Quota: ' + this.currentQuota + ' of ' + this.expectedQuota);
  }
}
ISalesPerson.prototype = new IEmployee;

//------------------------------------------------------------
// Instantiate each class, demonstrating how they work
//------------------------------------------------------------
adam = new IEmployee('Adam', 'Engineering');
adam.work();

bob = new IManager('Bob', 'VP of Development');                                  
bob.work();

john = new ISalesPerson('John', 'Corporate Sales', 5000);
john.sell(1000);
