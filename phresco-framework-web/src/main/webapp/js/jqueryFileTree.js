/*
 * ###
 * Framework Web Archive
 * %%
 * Copyright (C) 1999 - 2012 Photon Infotech Inc.
 * %%
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ###
 */
// jQuery File Tree Plugin
//
// Version 1.01
//
// Cory S.N. LaViska
// A Beautiful Site (http://abeautifulsite.net/)
// 24 March 2008
//
// Visit http://abeautifulsite.net/notebook.php?article=58 for more information
//
// Usage: $('.fileTreeDemo').fileTree( options, callback )
//
// Options:  root           - root folder to display; default = /
//           script         - location of the serverside AJAX file to use; default = jqueryFileTree.php
//           folderEvent    - event to trigger expand/collapse; default = click
//           expandSpeed    - default = 500 (ms); use -1 for no animation
//           collapseSpeed  - default = 500 (ms); use -1 for no animation
//           expandEasing   - easing function to use on expand (optional)
//           collapseEasing - easing function to use on collapse (optional)
//           multiFolder    - whether or not to limit the browser to one subfolder at a time
//           loadMessage    - Message to display while initial tree loads (can be HTML)
//
// History:
//
// 1.01 - updated to work with foreign characters in directory/file names (12 April 2008)
// 1.00 - released (24 March 2008)
//
// TERMS OF USE
// 
// This plugin is dual-licensed under the GNU General Public License and the MIT License and
// is copyright 2008 A Beautiful Site, LLC. 
//
if(jQuery) (function($){
	
	$.extend($.fn, {
		fileTree: function(o, h) {
			// Defaults
			if( !o ) var o = {};
			if( o.root == undefined ) o.root = '/';
			if( o.script == undefined ) o.script = 'jqueryFileTree.jsp';
			if( o.folderEvent == undefined ) o.folderEvent = 'click';
			if( o.expandSpeed == undefined ) o.expandSpeed= 500;
			if( o.collapseSpeed == undefined ) o.collapseSpeed= 500;
			if( o.expandEasing == undefined ) o.expandEasing = null;
			if( o.collapseEasing == undefined ) o.collapseEasing = null;
			if( o.multiFolder == undefined ) o.multiFolder = true;
			if( o.loadMessage == undefined ) o.loadMessage = 'Loading...';
			if( o.fileTypes == undefined ) o.fileTypes = '.';
			if( o.fileOrFolder == undefined ) o.fileOrFolder = 'all';
			if( o.minifiedFiles == undefined ) o.minifiedFiles = '';
			if( o.from == undefined ) o.from = '';
			var rootDirectory = o.root;
			$(this).each( function() {
				
				function showTree(c, t, fileTypes, fileOrFolder, from, minifiedFiles) {
					$(c).addClass('wait');
					$(".jqueryFileTree.start").remove();
					// posting values to jqueryFileTree.jsp
					$.post(o.script, { dir: t , restrictFileTypes: fileTypes, filesOrFolders: fileOrFolder, rootDir: rootDirectory, fromPage: from, minifiedFilesList : minifiedFiles}, function(data) {
						$(c).find('.start').html('');
						$(c).removeClass('wait').append(data);
						if( o.root == t ) $(c).find('UL:hidden').show(); else $(c).find('UL:hidden').slideDown({ duration: o.expandSpeed, easing: o.expandEasing });
						bindTree(c, fileOrFolder);
					});
				}
				
				function bindTree(t, fileOrFolder) {
					$(t).find('LI A').bind(o.folderEvent, function() {
						$('LI A').removeClass("selectedFolder");//To remove the background of the previously selected folder
						if( $(this).parent().hasClass('directory') ) {
							$(this).addClass("selectedFolder");//To set the background of the currently selected folder
							if( $(this).parent().hasClass('collapsed') ) {
								// Expand
								if( !o.multiFolder ) {
									$(this).parent().parent().find('UL').slideUp({ duration: o.collapseSpeed, easing: o.collapseEasing });
									$(this).parent().parent().find('LI.directory').removeClass('expanded').addClass('collapsed');
								}
								$(this).parent().find('UL').remove(); // cleanup
								showTree( $(this).parent(), escape($(this).attr('rel').match( /.*\// )), escape(o.fileTypes), escape(o.fileOrFolder), escape(o.from), escape(o.minifiedFiles));
								$(this).parent().removeClass('collapsed').addClass('expanded');
							} else {
								// Collapse
								$(this).parent().find('UL').slideUp({ duration: o.collapseSpeed, easing: o.collapseEasing });
								$(this).parent().removeClass('expanded').addClass('collapsed');
							}
							if(fileOrFolder == 'All') {
								h($(this).attr('rel'));	
							} else if(fileOrFolder == 'Folder') {
								h($(this).attr('rel'));
							} else if(fileOrFolder == 'File') {
								h('');
							}
						} else if( $(this).parent().hasClass('ext_jar') ) { 
							$(this).addClass("selectedFolder");//To highlight selected jar file 
							h($(this).attr('rel'));//To add its path in attribute - rel   
//						} else if( $(this).parent().hasClass('ext_xlsx') ) { 
//							$(this).addClass("selectedFolder");//To highlight selected jar file 
//							h($(this).attr('rel'));//To add its path in attribute - rel 
						} else if( $(this).parent().hasClass('ext_crt') ) { 
							$(this).addClass("selectedFolder");//To highlight selected crt file 
							h($(this).attr('rel'));//To add its path in attribute - rel   
						} else {
							if(fileOrFolder == 'All') {
								h($(this).attr('rel'));	
							} else if(fileOrFolder == 'Folder') {
								h('');
							} else if(fileOrFolder == 'File') {
								h($(this).attr('rel'));
							}
						}
						return false;
					});
					// Prevent A from triggering the # on non-click events
					if( o.folderEvent.toLowerCase != 'click' ) $(t).find('LI A').bind('click', function() { return false; });
				}
				// Loading message
				$(this).html('<ul class="jqueryFileTree start"><li class="wait">' + o.loadMessage + '<li></ul>');
				// Get the initial file list
				showTree( $(this), escape(o.root), escape(o.fileTypes), escape(o.fileOrFolder), escape(o.from), escape(o.minifiedFiles) );
			});
		}
	});
	
})(jQuery);