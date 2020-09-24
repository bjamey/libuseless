// ----------------------------------------------------------------------------
//                                      DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
// Title: Add line numbers to text
//
// Date : 15/05/2007
// By   : FSL
// ----------------------------------------------------------------------------

public void ConvertText()
{
    StringBuilder     output = new StringBuilder();

    try
    {
        char[]        end_of_line = {(char)10};
        string[]      lines = this.Text.Split( end_of_line );

        int    line_count = lines.GetUpperBound(0)+1;
        int    linenumber_max_width = line_count.ToString().Length;
        string padding = new String( ' ', this.LineNumberPaddingWidth);

        for ( int i=0; i<line_count; i++ )
        {
            output.Append( this.GetFormattedLineNumber( i+1,
                              linenumber_max_width, padding ) );
            output.Append( lines[i] );
            output.Append( "\r\n" );
        }

        if ( this.ConvertTabsToSpaces )
        {
            string spaces = new String( ' ', this.TabToSpacesWidth);
            output = output.Replace( "\t",  spaces );
        }
    }
    catch ( Exception e )
    {
        output.Append( e.Message );
    }

    this.Text = output.ToString();
}
