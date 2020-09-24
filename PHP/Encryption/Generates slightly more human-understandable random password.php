<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: Generates slightly more human-understandable random password

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/**
 * This function creates relatively secure random passwords.
 * It's by no means ideal, but it should work in most non-critical
 * situations. The nice thing is the generator attempts to create
 * passwords that people can pronounce and chooses letters that
 * won't be mistaken for others (such as the numeral "1", an
 * upper-case "i" and a lower-case "L"). To keep the code short
 * much of this functionality is very rudimentary, but it's better
 * than nothing.
 *
 * @param int $len
 * @return string
 */
function makePassword($len = 8)
{
        $vowels = array('a', 'e', 'i', 'o', 'u', 'y');
        $confusing = array('I', 'l', '1', 'O', '0');
        $replacements = array('A', 'k', '3', 'U', '9');
        $choices = array(0 => rand(0, 1), 1 => rand(0, 1), 2 => rand(0, 2));
        $parts = array(0 => '', 1 => '', 2 => '');

        if ($choices[0]) $parts[0] = rand(1, rand(9,99));
        if ($choices[1]) $parts[2] = rand(1, rand(9,99));

        $len -= (strlen($parts[0]) + strlen($parts[2]));
        for ($i = 0; $i < $len; $i++)
        {
                if ($i % 2 == 0)
                {
                        do $con = chr(rand(97, 122));
                        while (in_array($con, $vowels));
                        $parts[1] .= $con;
                }
                else
                {
                        $parts[1] .= $vowels[array_rand($vowels)];
                }
        }
        if ($choices[2]) $parts[1] = ucfirst($parts[1]);
        if ($choices[2] == 2) $parts[1] = strrev($parts[1]);

        $r = $parts[0] . $parts[1] . $parts[2];
        $r = str_replace($confusing, $replacements, $r);
        return $r;
}

/*
And here are a few generated passwords:

 1. 9xekek33
 2. Makoryxu
 3. 37mahyz5
 4. 9jitoz35
 5. gugipe38
 6. Xemyvare
 7. 33iciQ39
 8. Boxycusa
 9. 39yqymyX
10. 36huwup3
11. ikiwyR28
12. apaqyV33
13. 9votuf35
14. qehuvo35
15. Cojafe23
16. sakediky
17. 39sirody
18. Potewube
19. cejitira
20. Hukugop3
*/

/**
 * EXAMPLE:
 */

echo makePassword(12);

?>
