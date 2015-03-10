/*
 *   Copyright (C) 2011 Gitorious AS
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.gitorious.http;

import org.eclipse.jgit.http.server.resolver.*;
import javax.servlet.http.HttpServletRequest;

import org.eclipse.jgit.errors.RepositoryNotFoundException;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.lib.RepositoryCache;
import org.eclipse.jgit.lib.RepositoryCache.FileKey;
import org.eclipse.jgit.util.FS;
import java.io.File;
import java.io.IOException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import java.io.*;
import org.apache.log4j.Logger;
import org.apache.log4j.BasicConfigurator;
import java.util.HashMap;


/*
 * This is a class that implements looking up Gitorious paths from 
 * the database.
 * Currently it's quite error prone, but works. Kind of
 */
class GitoriousResolver implements RepositoryResolver {
    private String repositoryRoot;
    private String permissionBaseUri;
    private static Logger logger = Logger.getLogger("org.gitorious");
    private static HashMap<String, String> repositoryMap = new HashMap<String,String>();
    static {
        logger.setLevel(org.apache.log4j.Level.INFO);
        BasicConfigurator.configure();
    }

    public Repository open(HttpServletRequest req, String name)
        throws RepositoryNotFoundException, ServiceNotAuthorizedException, 
               ServiceNotEnabledException {
        String realName = lookupName(name);
        if (realName == null) {
            throw new RepositoryNotFoundException(name);
        }
        try {
            File gitDir = new File(repositoryRoot, realName);
            Repository db = RepositoryCache.open(FileKey.lenient(gitDir, FS.DETECTED), true);
            return db;
        } catch (IOException io) {
            logger.error("ERROR: " + io.getMessage());
            throw new RepositoryNotFoundException(name);
        }
    }

    public void setRepositoryRoot(String repositoryRoot) {
        this.repositoryRoot = repositoryRoot;
    }

    public void setPermissionBaseUri(String uri) {
        this.permissionBaseUri = uri;
    }

    private static void cacheUrl(String url, String path) {
        logger.info("Caching " + url);
        repositoryMap.put(url, path);
    }

    private static String loadFromCache(String url) {
        return repositoryMap.get(url);
    }

    public String lookupName(String in){
        String cachedResult = loadFromCache(in);
        if (cachedResult != null) {
            logger.info("Found " + in + " in cache");
            return cachedResult;
        }
        try {
            DefaultHttpClient client = new DefaultHttpClient();
            String path = in.split("\\.git")[0];

            // Should be /project/repository/config

            String url = permissionBaseUri + path + "/config";

            HttpGet httpGet = new HttpGet(url);

            HttpResponse response = client.execute(httpGet);

            int responseCode = response.getStatusLine().getStatusCode();
            if (responseCode != 200) {
                return null;
            }

            HttpEntity entity = response.getEntity();
            
            InputStream is = entity.getContent();

            InputStreamReader reader = new InputStreamReader(is);
            BufferedReader buff = new BufferedReader(reader);

            String line = null;
            String result = null;
            
            while ((line = buff.readLine()) != null) {
                if (line.indexOf("real_path") != -1) {
                    result = line.split("real_path:")[1];
                }
            }
            
            is.close();
            String fullPath =  result;
            cacheUrl(in, fullPath);
            return fullPath;
        } catch (Exception e) {
            logger.error(e.getMessage());
            return null;
        }
    }
}