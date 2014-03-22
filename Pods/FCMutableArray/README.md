FCMutableArray
==============

FCMutableArray is a composite class that behaves in the same way than an NSMutableArray, adding a delegate to it. 


The delegate is informed each time an object is added or removed from the array, and is also asked the permission to do so. That makes FCMutableArray a very good candidate to manage object queues. 


For example, if you want to manage a queue of `UILabel`s that simply represent an `NSString`, you can add the `NSString`s to your FCMutableArray, and transform them into `UILabel`s with the delegate:

```objc
- (BOOL)shouldAddObject:(id)object toArray:(FCMutableArray *)array {
    if ([object isKindOfClass:[NSString class]]) {
        UILabel *myLabel = [[UILabel alloc] init];  
        myLabel.text = object;
        return NO;
    }
}
```

##Performances
As you can see in the sample included in this repository, I consistently find `FCMutableArray`s to be _at least_ 20~30x slower than a regular NSMutableArray. This is the minimal footprint it adds to your program, with a delegate implementing all the methods, but not doing anything in them. This difference doesn't matter for smal to medium arrays (<500 objects), but FCMutableArray for sure shouldn't be considered for large data handlings. 
