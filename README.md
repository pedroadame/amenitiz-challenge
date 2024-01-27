# Store with cash register app
This app allows the user to choose products and view the total price of the checkout process taking in account specific
pricing rules.

### Available products
| Product Code | Product      | Price   |
|--------------|--------------|---------|
| GR1          | Green Tea    | 3.11 €  |
| SR1          | Strawberries | 5.00 €  |
| CF1          | Coffee       | 11.23 € |

### Special rules

- Buy-one-get-one-free (aka 2x1) on Green Tea
- Three or more Strawberries for 4.50 € each.
- Three or more Coffees for 2/3 of original price each.

### Test data

| Basket              | Total Price Expected |
|---------------------|----------------------|
| GR1,GR1             | 3.11 €               |
| SR1,SR1,GR1,SR1     | 16.61 €              |
| GR1,CF1,SR1,CF1,CF1 | 30.57 €              |

### Installing and running

Requisites:
- Ruby ~> 3.2

- Run `bundle install` from the root directory
- Run `bundle exec rspec` to run the test suite
- Run `bundle exec ruby bin/store` to try the app
