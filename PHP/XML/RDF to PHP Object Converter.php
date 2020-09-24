<?php /* ----------------------------------------------------------------------
                                        DTT 2.1.5.2  (c)2007 FSL - FreeSoftLand
   Title: RDF to PHP Object Converter

   Date : 24/05/2007
   By   : FSL
---------------------------------------------------------------------------- */

/* $Id: rdfworld-class.php,v 1.2 2003/02/25 03:43:44 csnyder Exp $ */

// rdfworld: schlepping rdf into a PHP object model, for fun and profit
//
// utilizes Chris Bizer's RDF API for PHP v0.4 (GPL)
//    see: http://sourceforge.net/projects/rdfapi-php/
//
// inspired by Aaron Swartz's TRAMP for Python: http://www.aaronsw.com/2002/tramp

// 2003-02-24: Better namespace guessing, support for untyped resources (rdf:Description only)
// 2003-02-19: Initial development

/* Copyright 2003 by Chris Snyder

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*/

define("RDFAPI_INCLUDE_DIR", "$rdfworldroot/rdfapi-php/api/");
include_once(RDFAPI_INCLUDE_DIR . "RdfAPI.php");

class World {
        // a World discovers and manages a collection of things
        var $rdf;                // actual rdf for this world
        var $model;                // triples model of world
        var $nsregistry;        // a namespace uri <-> nickname index
        var $_populated;        // indicates that world has been populate()ed
        var $_uknsindex;        // in case of unknown namespaces
        var $_untypedResources;        // array of rdf:Description resources

        function World($rdf="") {
                // hello world. heh.
                $this->model= new Model;
                $this->_uknsindex= 0;
                $this->_untypedResources= array();

                // create a namespace registry
                $this->nsregistry= array(
                        "rdf"=>"http://www.w3.org/1999/02/22-rdf-syntax-ns#",
                        "rdfs"=>"http://www.w3.org/2000/01/rdf-schema#",
                        "rss"=>"http://purl.org/rss/1.0/",
                        "dc"=>"http://purl.org/dc/elements/1.1/",
                        "foaf"=>"http://xmlns.com/foaf/0.1/",
                        "cc"=>"http://web.resource.org/cc/",
                        "daml"=>"http://www.daml.org/2001/03/daml+oil#",
                        "log"=>"http://www.w3.org/2000/10/swap/log#",
                        "doc"=>"http://www.w3.org/2000/10/swap/pim/doc#",
                        "content"=>"http://purl.org/rss/1.0/modules/content/"
                        );

                // if RDF is supplied, populate the world now
                if ($rdf) $this->populate($rdf);

                rdfwdebug("World created.",1);
                }

        function populate($rdf) {
                // "populates" world
                if ($this->_populated==1) {
                        // until model->unite() is working, we have to fail here
                        rdfwdebug("World->populate called, but world is already populated.",1);
                        return 0;
                        }

                // create a parser and use it to generate a RdfAPI Model of triples
                $parser = new RdfParser();
                $newmodel =& $parser->generateModel($rdf);

                // add that model to the existing world model
                // this isn't implemented yet in RdfAPI :-(
                //$this->model->unite($newmodel);
                $this->model= $newmodel;
                $this->_populated= 1;

                // update $this->nsregistry as needed... see RDFUtil::getNamespace($Resource)

                // append the rdf... is this a good idea?
                $this->rdf.= "$rdf";
                rdfwdebug("World populated.",1);
                rdfwdebug("-- with rdf:<blockquote><pre>".nl2br(htmlentities($rdf))."</pre></blockquote>",2);
                }

        function getThingTypes() {
                // returns an associative array consisting of types of things in a world
                rdfwdebug("World->getThingTypes() called.",1);
                $typearray= array();
                $knownResources= array();
                $ukindex= 1;

                // lookup all the rdf:type statements
                $predicate= new Resource("http://www.w3.org/1999/02/22-rdf-syntax-ns#type");
                $typemodel= $this->model->find(NULL, $predicate, NULL);

                // now for each subject uri in $typemodel...
                foreach($typemodel->triples AS $statement) {
                        // get the object uri
                        $objectobj= $statement->getObject();
                        $object= $objectobj->getURI();
                        rdfwdebug("World->getThingTypes: found object=$object",2);

                        // add subject to the array of known Resources
                        $subjectobj= $statement->getSubject();
                        $subject= $subjectobj->getURI();
                        $knownResources[]= $subject;
                        rdfwdebug("World->getThingTypes: added $subject to knownResources array.",2);

                        // split off fragment
                        $hasfragment= strrpos($object, "#");
                        if ($hasfragment!==false) {
                                // type name is a fragment
                                $namespace= substr($object, 0, $hasfragment+1);
                                $property= substr($object, $hasfragment+1);
                                }
                        else {
                                // type name is at end of path
                                $lastslash= strrpos($object, "/");
                                if ($lastslash!==false) {
                                        $namespace= substr($object, 0, $lastslash+1);
                                        $property= substr($object, $lastslash+1);
                                        }
                                else {
                                        // uh-oh, what's the type name? Help!
                                        rdfwdebug("World->getThingTypes() couldn't determine type name.",1);
                                        $namespace= $object;
                                        $property= "unknown".$ukindex;
                                        $ukindex++;
                                        }
                                }

                        // find $ns from $namespace
                        $ns= $this->getNs($namespace);
                        if ($ns=="") {
                                // add namespace to registry as something like ns1, ns2, etc...
                                $this->addNamespace($namespace);
                                $ns= $this->getNs($namespace);
                                }

                        // wrap it up
                        $key= "$ns_$property";
                        $typearray[$key]= "$ns:$property";
                        rdfwdebug("World->getThingTypes: setting typearray[$key]=$typearray[$key]",1);
                        }

                // unfortunately, there may be Resources here with no rdf:type!!!
                // scan through all the statements in the model and compare to known uris. (sigh)
                foreach ($this->model->triples AS $statement) {
                        // check the subject against the array of known Resources
                        $subjectobj= $statement->getSubject();
                        $subject= $subjectobj->getURI();
                        if (in_array($subject, $knownResources)) continue;

                        // untyped Resource found
                        $knownResources[]= $subject;
                        rdfwdebug("World->getThingTypes: added $subject (untyped) to knownResources array.",2);
                        if ($typearray['rdfs_Resouce']=="") {
                                $key= "rdfs_Resource";
                                $typearray[$key]= "rdfs:Resource";
                                rdfwdebug("World->getThingTypes: setting typearray[$key]=$typearray[$key]",1);
                                }
                        $this->_untypedResources[]= $subject;
                        rdfwdebug("World->getThingTypes: adding $subject to this->_untypedResources array.",1);
                        }

                rdfwdebug("World->getThingTypes: found ".count($typearray)." different types of things. (And ".count($this->_untypedResources)." untyped Resources.)",1);
                return $typearray;

                // end getThingTypes()
                }

        function getThingsByType($typename) {
                // returns an array of Things of a certain type from the model
                rdfwdebug("World->getThingsByType($typename) called.",1);
                $thingarray= array();
                $n= 0;

                // $typename looks like "ns:type" where ns is a registered namespace and type is, well, a type
                // --UNLESS, $typename=="rdfs:Resource" in which case we're looking for untyped resources.
                if ($typename!="rdfs:Resource") {
                        $tnarray= explode(":",$typename);
                        $ns= $tnarray[0];
                        $type= $tnarray[1];

                        // contruct the typeuri
                        $namespace= $this->getNamespace($ns);
                        $typeuri= $namespace.$type;
                        rdfwdebug("World->getThingsByType: typeuri=$typeuri",1);

                        // now find all the resources in the model with
                        // predicate= http://www.w3.org/1999/02/22-rdf-syntax-ns#type
                        // and object= $typeuri
                        if ($typeuri!="") {
                                $typeresource= new Resource($typeuri);
                                }
                        else $typeresource= NULL;
                        $predicate= new Resource("http://www.w3.org/1999/02/22-rdf-syntax-ns#type");
                        $typemodel= $this->model->find(NULL, $predicate, $typeresource);

                        // now for each subject uri in $typemodel...
                        foreach($typemodel->triples AS $statement) {
                                // get all the triples that apply to this resource
                                $currentsubject= $statement->getSubject();
                                rdfwdebug("World->getThingsByType: subject[$n]=".$currentsubject->getURI(),1);
                                $thingmodel= $this->model->find($currentsubject, NULL, NULL);

                                // and make a populated Thing out of it, added to the thingarray
                                rdfwdebug("World->getThingsByType: making a Thing:<blockquote>",1);
                                $thingarray[$n]= new Thing;
                                $thingarray[$n]->fromModel($thingmodel, $this);
                                rdfwdebug("</blockquote>",1);

                                // recycle
                                unset($thingmodel);
                                $n++;
                                }
                        // recycle
                        unset($typemodel);
                        }
                else {
                        // $typename=="rdfs:Resouce" so get all the $this->_untypedResources together
                        foreach($this->_untypedResources AS $subjectUri) {
                                // get all the triples that apply to this resource
                                $currentsubject= new Resource($subjectUri);
                                rdfwdebug("World->getThingsByType: subject[$n]=".$currentsubject->getURI(),1);
                                $thingmodel= $this->model->find($currentsubject, NULL, NULL);

                                // and make a populated Thing out of it, added to the thingarray
                                rdfwdebug("World->getThingsByType: making a Thing:<blockquote>",1);
                                $thingarray[$n]= new Thing;
                                $thingarray[$n]->fromModel($thingmodel, $this);
                                rdfwdebug("</blockquote>",1);

                                // recycle
                                unset($thingmodel);
                                $n++;
                                }
                        }

                // return the array of found Things
                rdfwdebug("World->getThingsByType: found ".count($thingarray)." things.",1);
                return $thingarray;

                // end getThingsByType()
                }

        function addNamespace($namespace, $key="") {
                // adds $namespace as $this->nsregistry[$key], or $this->nsregistry["ns$this->_uknsindex"]
                if ($key=="") {
                        $this->_uknsindex++;
                        $key= "ns".$this->_uknsindex;
                        }
                // overwrite is not allowed???
                if ($this->nsregistry[$key]!="") {
                        rdfwdebug("addNamespace tried to add $namespace as $key, but there is already another namespace at $key.",1);
                        return 0;
                        }

                // make the assignment
                $this->nsregistry[$key]= $namespace;
                return $key;
                }

        function getNamespace($ns) {
                // from rss to http://purl.org/rss/1.0/
                if ($this->nsregistry[$ns]!="") $namespace= $this->nsregistry[$ns];
                else {
                        // else do a little rdf parse and see if you can get it.
                        $search= "xmlns:$ns=";
                        $xmlnsloc= strpos($this->rdf, $search);
                        if ($xmlnsloc!==false) {
                                // namespace has quotes we hope...
                                $xmlnsloc++;
                                $endquoteloc= strpos($this->rdf, "\"", $xmlnsloc);         //"
                                $namespacelen= $endquoteloc - $xmlnsloc;
                                $namespace= substr($this->rdf, $xmlnsloc, $namespacelen);
                                rdfwdebug("World->getNamespace($ns): found $namespace after parsing rdf, will add to nsregistry now.",1);
                                $this->addNamespace($namespace, $ns);
                                }
                        else $namespace= "";
                        }

                rdfwdebug("--World->getNamespace($ns): found $namespace",2);
                return $namespace;
                }

        function getNs($namespace) {
                // from http://purl.org/rss/1.0/ to rss
                $ns= array_search($namespace, $this->nsregistry);

                if ($ns=="") {
                        // do a regex on the rdf and see if you can get it...
                        $pattern= "{xmlns:(.+)=\"$namespace\"}";
                        rdfwdebug("World->getNs($namespace): pattern=$pattern",2);
                        $void= preg_match($pattern, $this->rdf, $matches);
                        if ($void) {
                                $ns= $matches[1];
                                rdfwdebug("World->getNs($namespace): found previously unknown namespace $ns ($matches[0]). Will add to nsregistry now.",1);
                                $this->addNamespace($namespace, $ns);
                                }
                        else $ns= "";
                        }

                rdfwdebug("--World->getNs($namespace): found $ns",2);
                return $ns;
                }

        // end World class
        }


class Thing {
        // a Thing is a PHP object with properties translated from RDF
        var $uri;        // uri of thing
        var $type;        // rdf:type of thing
        var $model;        // triples model of self
        var $world;        // containing world
        var $_ukindex;  // in case of ambiguous property names

        function Thing() {
                // yep, you're a thing
                $this->type= "http://www.w3.org/2000/01/rdf-schema#Resource";
                $this->_ukindex= 0;
                }

        function fromModel($model, &$world) {
                // takes a model consisting of triples about a single object and builds a thing out of it
                // aka "The Tricky Part"
                rdfwdebug("Thing->fromModel called on a ".get_class($model)." that came from a ".get_class($world),1);
                $this->model= $model;
                $this->world= $world;  // is this a good idea? hmmm.

                // for each triple in the model:
                foreach($this->model->triples AS $statement) {
                        // 1) verify that it is referencing the right subject... paranoid?
                        $currentsubject= $statement->getSubject();
                        if ($this->uri=="") {
                                $this->uri= $currentsubject->getURI();
                                rdfwdebug("Thing->fromModel subject is $this->uri",1);
                                }
                        elseif ($this->uri!= $currentsubject->getURI()) {
                                rdfwdebug("Thing->fromModel found a misattributed statement: expected $this->uri, got ".$currentsubject->getURI(),0);
                                continue;
                                }

                        // 2) determine what namespace:property is being expressed
                        $nameresource= $statement->getPredicate();
                        $namespaceproperty= $nameresource->getURI();
                        $hasfragment= strrpos($namespaceproperty, "#");
                        if ($hasfragment!==false) {
                                // property name is a fragment
                                $namespace= substr($namespaceproperty, 0, $hasfragment+1);
                                $property= substr($namespaceproperty, $hasfragment+1);
                                }
                        else {
                                // property name is at end of path
                                $lastslash= strrpos($namespaceproperty, "/");
                                if ($lastslash!==false) {
                                        $namespace= substr($namespaceproperty, 0, $lastslash+1);
                                        $property= substr($namespaceproperty, $lastslash+1);
                                        }
                                else {
                                        // uh-oh, what's the property name and what's the namespace? Help!
                                        rdfwdebug("Thing->fromModel can't determine ns:property from $namespaceproperty. Tsk.",1);
                                        $namespace= $namespaceproperty;
                                        $property= "unknown".$this->_ukindex;
                                        $this->_ukindex++;
                                        }
                                }
                        rdfwdebug("--Thing->fromModel assigning (long) $namespace$property.",2);

                        // 3) convert namespace to ns_, or blank for rdf, or just _ if unknown
                        $ns= $this->world->getNs($namespace);
                        if ($ns=="rdf") $ns= "";
                        else $ns.= "_";
                        rdfwdebug("--Thing->fromModel: ns=$ns",2);

                        // 4) make the assignment as ns_property, or just property in the case of rdf
                        $propertyname= $ns.$property;
                        $currentobject= $statement->getObject();
                        $this->{$propertyname}= $currentobject->getLabel();
                        rdfwdebug("Thing->fromModel set this->$propertyname=".htmlentities($currentobject->getLabel()),1);

                        // end foreach statement loop
                        }

                // end $thing->fromModel()
                }

        function getPropertiesList() {
                // generates an html properties list for the object
                $array= get_object_vars($this);
                $list= "<hr><b>".get_class($this)." values:</b><blockquote>";
                while (list($key, $val)= each($array)) {
                        if (is_int($key)) continue;
                        $list= $list."\$this->$key= $val<br>";
                        // recursive
                        if (0 && is_object($val)) {
                                $list= $list.$val->getPropertiesList();
                                }
                        }
                $list= $list."---End of ".get_class($this)."---</blockquote>";
                return $list;
                }

        // end Thing class
        }

// error channel and debug mechanism -- not part of any class!!!
$rdfw_error= "rdfworld.php: ".'$Id: rdfworld-class.php,v 1.2 2003/02/25 03:43:44 csnyder Exp $'."<br />
                error level=$_REQUEST[debug]<br /><br />";
function rdfwdebug($message,$level=0) {
        global $rdfw_error;
        if ($_REQUEST['debug']!="" && $level <= $_REQUEST['debug']) {
                $rdfw_error.= $message."<br />";
                if ($level==0) {
                        print "<b>Fatal rdfworld.php error:</b> $message<hr />";
                        print $rdfw_error;
                        exit;
                        }
                }
        elseif ($level==0) {
                print "<b>Fatal rdfworld.php error:</b> $message";
                }

        // end rdfwdebug
        }
?>
