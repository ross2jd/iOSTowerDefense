//
//  AppDelegate.m
//  TowerDefense
//
//  Created by Jordan Ross on 1/10/15.
//  Copyright (c) 2015 Jordan Ross. All rights reserved.
//

#import "AppDelegate.h"
#import "Vertex.h"
#import "Edge.h"
#import "Graph.h"
#import "Dijkstra.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self test];
    return YES;
}

// TESTING Dijkstra's Algorithm
- (void) test
{
    // We want to start out by first trying to create a 5x5 graph. It will have 25 nodes.
    
    // |<----  width  ----->|
    // 00 - 01 - 02 - 03 - 04   -
    // 05 - 06 - 07 - 08 - 09   ^
    // 10 - 11 - 12 - 13 - 14   height
    // 15 - 16 - 19 - 18 - 19   v
    // 20 - 21 - 22 - 23 - 24   -
    int width = 5;
    int height = 5;
    int numVertices = width * height;
    int rowIdx = 0;
    int colIdx = 0;
    int numEdges = 2*width*height - width - height;
    
    // Create an empty list of edges
    NSMutableArray *edgeList = [NSMutableArray new];
    
    // Create a set of vertices
    NSMutableArray *vertexList = [NSMutableArray new];
    
    for (int i = 0; i < numVertices; i++)
    {
        Vertex *v = [Vertex new];
        v.name = [NSString stringWithFormat:@"%i",i];
        v.vertexId = i;
        [vertexList addObject:v];
    }
    NSLog(@"Vertex list is of size: %lu", (unsigned long)[vertexList count]);
    
    // Create a list of vertex pairs that will make up the path
    NSArray *path = @[@10, @11, @12, @13, @14];
    
    // Create empty vertices for the start and end
    Vertex *startVertex;
    Vertex *endVertex;
    
    for (int i = 0; i < numVertices; i++) {
        // Get the current vertex and the right and bottom neighbors
        Vertex *curVertex = [vertexList objectAtIndex:i];
        
        if (i == [[path firstObject] integerValue])
        {
            // If we have the starting vertex then save it
            startVertex = curVertex;
        }
        if (i == [[path lastObject] integerValue])
        {
            // If we have the ending vertex then save it
            endVertex = curVertex;
        }
        
        
        if (colIdx < (width - 1))
        {
            Vertex *rightNeighbor = [vertexList objectAtIndex:(i+1)];
            // We don't have any edges to nodes at higher col indexes if we are the last column
            Edge *rightEdge = [Edge new];
            Edge *leftEdge = [Edge new];
            rightEdge.source = curVertex;
            rightEdge.destination = rightNeighbor;
            leftEdge.source = rightNeighbor;
            leftEdge.destination = curVertex;
            if ([path containsObject:[NSNumber numberWithInt:i]] && [path containsObject:[NSNumber numberWithInt:(i+1)]])
            {
                rightEdge.distances = @[[NSNumber numberWithInteger:1]];
                leftEdge.distances = @[[NSNumber numberWithInteger:1]];
            }
            else
            {
                rightEdge.distances = @[[NSNumber numberWithInteger:numEdges]];
                leftEdge.distances = @[[NSNumber numberWithInteger:numEdges]];
            }
            [edgeList addObject:rightEdge];
            [edgeList addObject:leftEdge];
        }
        if (rowIdx < (height - 1))
        {
            Vertex *downNeighbor = [vertexList objectAtIndex:(i+width)];
            // We don't have any edges to nodes at higher row indexes if we are the last row
            Edge *downEdge = [Edge new];
            Edge *upEdge = [Edge new];
            downEdge.source = curVertex;
            downEdge.destination = downNeighbor;
            upEdge.source = downNeighbor;
            upEdge.destination = curVertex;
            if ([path containsObject:[NSNumber numberWithInt:i]] && [path containsObject:[NSNumber numberWithInt:(i+width)]])
            {
                downEdge.distances = @[[NSNumber numberWithInteger:1]];
                upEdge.distances = @[[NSNumber numberWithInteger:1]];
            }
            else
            {
                downEdge.distances = @[[NSNumber numberWithInteger:numEdges]];
                upEdge.distances = @[[NSNumber numberWithInteger:numEdges]];
            }
            [edgeList addObject:downEdge];
            [edgeList addObject:upEdge];
        }
        
        if ((i+1) % width == 0 && i != 0)
        {
            rowIdx++;
            colIdx = 0;
        }
        else
        {
            colIdx++;
        }
    }
    
    // Create an empty graph
    Graph *graph = [Graph new];
    
    // Add the vertecies and edges to the graph
    [[graph edgeList] addObjectsFromArray:edgeList];
    [[graph vertexList] addObjectsFromArray:vertexList];
    
    NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate] * 1000;
    
    Dijkstra *dijkstra = [Dijkstra new];
    [dijkstra initWithGraph:graph];
    [dijkstra execute:startVertex];
    
    NSTimeInterval stopTime = [NSDate timeIntervalSinceReferenceDate] * 1000;
    
    NSArray *shortestPath = [dijkstra getPath:[graph.vertexList objectAtIndex:[[path lastObject] integerValue]]];
    NSLog(@"* Path");
    for (Vertex *vertex in shortestPath) {
        NSLog(@"- %@",vertex.name);
    }
    
    NSLog(@"Duration : %lf",stopTime-startTime);
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
