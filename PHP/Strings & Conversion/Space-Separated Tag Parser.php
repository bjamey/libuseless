<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Space-Separated Tag Parser

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/**
 * Parses a String of Tags
 *
 * Tags are space delimited. Either single or double quotes mark a phrase.
 * Odd quotes will cause everything on their right to reflect as one single
 * tag or phrase. All white-space within a phrase is converted to single
 * space characters. Quotes burried within tags are ignored! Duplicate tags
 * are ignored, even duplicate phrases that are equivalent.
 *
 * Returns an array of tags.
 */
function ParseTagString($sTagString)
{
        $arTags = array();                // Array of Output
        $cPhraseQuote = null;        // Record of the quote that opened the current phrase
        $sPhrase = null;                // Temp storage for the current phrase we are building

        // Define some constants
        static $sTokens = " \r\n\t";        // Space, Return, Newline, Tab
        static $sQuotes = "'\"";                // Single and Double Quotes '"

        // Start the State Machine
        do
        {
                // Get the next token, which may be the first
                $sToken = isset($sToken)? strtok($sTokens) : strtok($sTagString, $sTokens);

                // Are there more tokens?
                if ($sToken === false)
                {
                        // Ensure that the last phrase is marked as ended
                        $cPhraseQuote = null;
                }
                else
                {
                        // Are we within a phrase or not?
                        if ($cPhraseQuote !== null)
                        {
                                // Will the current token end the phrase?
                                if (substr($sToken, -1, 1) === $cPhraseQuote)
                                {
                                        // Trim the last character and add to the current phrase, with a single leading space if necessary
                                        if (strlen($sToken) > 1) $sPhrase .= ((strlen($sPhrase) > 0)? ' ' : null) . substr($sToken, 0, -1);
                                        $cPhraseQuote = null;
                                }
                                else
                                {
                                        // If not, add the token to the phrase, with a single leading space if necessary
                                        $sPhrase .= ((strlen($sPhrase) > 0)? ' ' : null) . $sToken;
                                }
                        }
                        else
                        {
                                // Will the current token start a phrase?
                                if (strpos($sQuotes, $sToken[0]) !== false)
                                {
                                        // Will the current token end the phrase?
                                        if ((strlen($sToken) > 1) && ($sToken[0] === substr($sToken, -1, 1)))
                                        {
                                                // The current token begins AND ends the phrase, trim the quotes
                                                $sPhrase = substr($sToken, 1, -1);
                                        }
                                        else
                                        {
                                                // Remove the leading quote
                                                $sPhrase = substr($sToken, 1);
                                                $cPhraseQuote = $sToken[0];
                                        }
                                }
                                else
                                        $sPhrase = $sToken;
                        }
                }

                // If, at this point, we are not within a phrase, the prepared phrase is complete and can be added to the array
                if (($cPhraseQuote === null) && ($sPhrase != null))
                {
                        $sPhrase = strtolower($sPhrase);
                        if (!in_array($sPhrase, $arTags)) $arTags[] = $sPhrase;
                        $sPhrase = null;
                }
        }
        while ($sToken !== false);        // Stop when we receive FALSE from strtok()
        return $arTags;
}

?>
