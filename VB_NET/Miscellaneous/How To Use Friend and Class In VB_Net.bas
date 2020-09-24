' -----------------------------------------------------------------------------
'                                       DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
'  Title: How To Use Friend and Class In VB·Net
' 
'  Date : 24/05/2007
'  By   : FSL
' -----------------------------------------------------------------------------

imports system

class singleton
        public shared s as singleton
        public shared  flag as boolean
        public i as String

        private sub new
            ' private constructor disallowing other to create object directly
        end sub

        friend shared function getSingletonObject as singleton
                if flag = false then
                        s = new singleton
                        flag = true
                        return s
                else
                        return s
                end if
        end function
end class

class test
        shared sub main
                dim o as singleton
                dim y as singleton
                o = singleton.getSingletonObject
                o.i = "Singleton"
                y = singleton.getSingletonObject
                console.writeline(y.i)
        end sub
end class
