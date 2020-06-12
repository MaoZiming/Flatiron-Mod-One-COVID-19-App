# Flatiron Module One Final Project: COVID-19 App
## Made by Ziming Mao and Chad Palmer

## Short Description

This app enables users to search for data on COVID-19 cases worldwide, hosted on the COVID-19 API (https://covid19api.com/), through a user-friendly interface. It also allows users to compare data from multiple countries and filter that data based on date and case type. The data compiled can also be plotted into graphs and exported as both graphs and text files. 

## Features

1. Filter Covid-19 data by one country, or by multiple countries
2. Filter Covid-19 data by one date, or by a range of dates
3. Output data in .txt files, as text or as graphs in ASCII format (files saved to repository directory)
4. Keep track of past queries and retrieve past queries if needed
5. Select case types, such as active cases, confirmed cases, number of deaths
6. Select the data type to be "cumulative" (i.e. total number of cases) or "daily" (i.e. new cases per day)

## Install instructions

To install the app, git clone the repository in your local directory. Run:
```ruby
bundle install
```
To install all required gems. Run:
```ruby
rake db:migrate 
```
To migrate all changes to the database. Finally, run 
```ruby
ruby bin/run.rb 
```
To run the app. 

## Contributor's guide

Pull requests are welcome. Please make sure that your PR is well-scoped.
For major changes, please open an issue first to discuss what you would like to change.

## License

MIT License

Copyright (c) 2020 Chad Palmer, Ziming Mao

> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.